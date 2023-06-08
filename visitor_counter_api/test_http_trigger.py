import unittest
from unittest.mock import MagicMock

from __init__ import *


class TestVisitorCounter(unittest.TestCase):
    def setUp(self):
        self.request = MagicMock()
        self.stored_visitors = '[{"PartitionKey": "uniqueVisitor", "RowKey": "hash1"}]'

    def test_main(self):
        self.request.method = 'GET'
        self.request.headers = {'user-agent': 'TestAgent', 'x-forwarded-for': '127.0.0.1'}
        newVisitor = MagicMock()

        response = main(self.request, self.stored_visitors, newVisitor)

        self.assertEqual(response.status_code, 200)
        newVisitor.set.assert_called_once()

    def test_main_incorrect_headers(self):
        self.request.method = 'GET'
        self.request.headers = {'user-agent-wrong': 'TestAgent'}
        newVisitor = MagicMock()

        response = main(self.request, self.stored_visitors, newVisitor)

        self.assertEqual(response.status_code, 200)
        newVisitor.set.assert_not_called()  # Verify that newVisitor.set() is not called

    def test_main_with_crawler(self):
        self.request.method = 'GET'
        self.request.headers = {'user-agent': 'Googlebot', 'x-forwarded-for': '127.0.0.1'}
        newVisitor = MagicMock()

        response = main(self.request, self.stored_visitors, newVisitor)

        self.assertEqual(response.status_code, 200)
        newVisitor.set.assert_not_called()  # Verify that newVisitor.set() is not called

    def test_main_options_request(self):
        self.request.method = 'OPTIONS'

        response = main(self.request, self.stored_visitors, None)

        self.assertEqual(response.status_code, 200)
        self.assertIn('Access-Control-Allow-Origin', response.headers)
        self.assertIn('Access-Control-Allow-Methods', response.headers)
        self.assertIn('Access-Control-Allow-Headers', response.headers)

    def test_generate_hash(self):
        original_string = 'TestString'
        expected_hash = hashlib.sha256(original_string.encode()).hexdigest()

        result = generate_hash(original_string)

        self.assertEqual(result, expected_hash)

    def test_is_crawler_with_crawler(self):
        user_agent = 'Googlebot'

        result = is_crawler(user_agent)

        self.assertTrue(result)

    def test_is_crawler_with_non_crawler(self):
        user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'

        result = is_crawler(user_agent)

        self.assertFalse(result)

    def test_is_unique_visitor_with_existing_visitor(self):
        visitor_hash = 'hash1'
        stored_visitors = [{"PartitionKey": "uniqueVisitor", "RowKey": "hash1"}]

        result = is_unique_visitor(visitor_hash, stored_visitors)

        self.assertFalse(result)

    def test_is_unique_visitor_with_new_visitor(self):
        visitor_hash = 'hash2'
        stored_visitors = [{"PartitionKey": "uniqueVisitor", "RowKey": "hash1"}]

        result = is_unique_visitor(visitor_hash, stored_visitors)

        self.assertTrue(result)

    def test_parse_ip_address_ipv4(self):
        client_ip = '127.0.0.1'

        result = parse_ip_address(client_ip)

        self.assertEqual(result, '127.0.0.1')

    def test_parse_ip_address_ipv6(self):
        client_ip = '[2001:db8::1]:8080'

        result = parse_ip_address(client_ip)

        self.assertEqual(result, '2001:db8::1')


if __name__ == '__main__':
    unittest.main()
