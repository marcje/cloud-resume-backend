import hashlib
import json
import logging

import azure.functions as func

def main(request: func.HttpRequest, storedVisitors: str, newVisitor: func.Out[str]) -> func.HttpResponse:
    # Setup CORS
    headers = {
        "Access-Control-Allow-Origin": "https://resume.itsburning.nl",
        "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type, Authorization"
    }
    if request.method == "OPTIONS":
        return func.HttpResponse(headers=headers)

    stored_visitors = json.loads(storedVisitors)
    json_result = json.dumps({"visitor_count": len(stored_visitors)})

    try:
        user_agent = request.headers['user-agent']
        client_ip = parse_ip_address(request.headers['x-forwarded-for'])
    except KeyError:
        logging.info(f"not storing visitor: unable to determine user agent or originating ip address")
        return func.HttpResponse(json_result, mimetype="application/json", status_code=200, headers=headers)

    if is_crawler(user_agent):
        logging.info(f"ignoring request: '{user_agent}' is listed in the known crawlers list")
        return func.HttpResponse(json_result, mimetype="application/json", status_code=200, headers=headers)

    visitor_hash = generate_hash(user_agent+client_ip)
    if is_unique_visitor(visitor_hash, stored_visitors):
        logging.info(f"storing unique visitor")
        data = {"PartitionKey": "uniqueVisitor",
                "RowKey": visitor_hash}
        newVisitor.set(json.dumps(data))
    return func.HttpResponse(json_result, mimetype="application/json", status_code=200, headers=headers)

def generate_hash(original_string: str) -> str:
    sha256_hash = hashlib.new("SHA256")
    sha256_hash.update(original_string.encode())
    return sha256_hash.hexdigest()

def is_crawler(user_agent: str) -> bool:
    # Prevent counting bots, skipping entries existing in top crawler list (https://www.keycdn.com/blog/web-crawlers).
    top_crawlers = ['Googlebot',
                    'Bingbot',
                    'Slurp',
                    'DuckDuckBot',
                    'Baiduspider',
                    'YandexBot',
                    'Sogou',
                    'Exabot',
                    'facebot',
                    'facebookexternalhit',
                    'Applebot',
                    'Nutch',
                    'Screaming Frog',
                    'Deepcrawl',
                    'Octoparse',
                    'HTTrack',
                    'SiteSucker',
                    'PetalBot',
                    'SEMrushBot',
                    'Majestic',
                    'DotBot',
                    'AhrefsBot']
    for crawler in top_crawlers:
        if crawler.lower() in user_agent.lower():
            return True
    return False

def is_unique_visitor(visitor_hash: str, stored_visitors: dict) -> bool:
    for visitor in stored_visitors:
        if visitor['RowKey'] == visitor_hash:
            logging.info("visitor has already been stored")
            return False
    return True

def parse_ip_address(client_ip: str) -> str:
    # Determine whether it is an IPv4 or IPv6 address and cut off the port number in the x-forwarded-for header.
    if client_ip.startswith("[") and client_ip.count(":") > 1:
        return client_ip.split("[")[1].split("]")[0]
    return client_ip.split(":")[0]

