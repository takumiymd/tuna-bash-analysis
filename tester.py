# tester.py
# Author Takumi Yamada
# Since April 12, 2026
# This is a test file for the output of tuna_analysis.sh in python
import unittest
import subprocess


class TestTunaAnalysis(unittest.TestCase):

    def test_tuna_analysis(self):
        test_cases = [
            {"Expected": "2016"},
            {"Expected": "Bluefin Tuna: 1008"},
            {"Expected": "Southern Bluefin Tuna: 672"},
            {"Expected": "Bigeye Tuna: 336"},
            {"Expected": "Fresh: 1344"},
            {"Expected": "Frozen: 672"},
            {"Expected": "Unknown Fleet: 1344"},
            {"Expected": "Japanese Fleet: 336"},
            {"Expected": "Foreign Fleet: 336"},
            {"Expected": "Average price: 2630.852"},
            {"Expected": "Minimum price: 519.0"},
            {"Expected": "Maximum price: 5137.0"},
            {"Expected": "Average quantity: 242.417"},
            {"Expected": "Minimum quantity: 0.003"},
            {"Expected": "Maximum quantity: 1207.033"},
        ]

        test_passed = True

        completed_process = subprocess.run(
            ["bash", "tuna_analysis.sh"], text=True, capture_output=True, timeout=100
        )

        print(["bash", "tuna_analysis.sh"])
        print("stdout:")
        print(completed_process.stdout)
        print("stderr:")
        print(completed_process.stderr)

        for test in test_cases:
            if test["Expected"].strip() not in completed_process.stdout.strip():
                test_passed = False
                print("Error for test case:")
                print(test)

        self.assertTrue(test_passed, "One or more test cases failed")


if __name__ == "__main__":
    unittest.main()
