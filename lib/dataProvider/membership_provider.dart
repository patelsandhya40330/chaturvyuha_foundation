import 'package:flutter/material.dart';

class MembershipProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> membershipTiers = [
    {
      "privilege": "Dawn Line Ganga Arati & Chanting",
      "Upasaka (Free)": "Weekly Sunday Live",
      "Sadhaka (\$18/mo)": "Daily Unlimited Live",
      "Upasaka (\$45/mo)": "Daily Unlimited Live",
      "Samrakshak (\$1,000)": "Lifetime Priority Live",
    },
    {
      "privilege": "Manuscript High-Res Digital Archive",
      "Upasaka (Free)": "10 Open-Access Texts",
      "Sadhaka (\$18/mo)": "150+ Vedic Commentaries",
      "Upasaka (\$45/mo)": "Full High-Res Scan Access",
      "Samrakshak (\$1,000)": "Full Palm-Leaf + Tape Scans",
    },
    {
      "privilege": "Ashram/Kutir Stay Allocation",
      "Upasaka (Free)": "—",
      "Sadhaka (\$18/mo)": "2 Nights / Year (Rishikesh)",
      "Upasaka (\$45/mo)": "7 Nights / Year Any Sanctum",
      "Samrakshak (\$1,000)": "21 Nights / Year Any Sanctum",
    },
    {
      "privilege": "1-on-1 Acharya Guidance Satsang",
      "Upasaka (Free)": "—",
      "Sadhaka (\$18/mo)": "Quarterly Group Satsang",
      "Upasaka (\$45/mo)": "Monthly Personal 45m Call",
      "Samrakshak (\$1,000)": "Direct WhatsApp Seat to Acharya",
    },
    {
      "privilege": "Tax Deduction Documentation",
      "Upasaka (Free)": "—",
      "Sadhaka (\$18/mo)": "Annual 80G/501c3 Receipt",
      "Upasaka (\$45/mo)": "Annual 80G/501c3 Receipt",
      "Samrakshak (\$1,000)": "Founder Gold Plaque + Receipt",
    },
  ];

  final List<Map<String, String>> faqs = [
    {
      "question": "Can I upgrade, pause, or switch my seeker tier anytime?",
      "answer":
          "Yes, you can manage your membership status through your Seeker Portal at any time. Changes take effect at the start of the next billing cycle.",
    },
    {
      "question":
          "How do I access the digital manuscript repository after logging in?",
      "answer":
          "Once logged in, navigate to the 'Archival Library' section. Based on your tier, you will see 'View High-Res' or 'Request Scan' buttons next to the catalog entries.",
    },
    {
      "question":
          "Are ashram retreat nights transferable to immediate family members?",
      "answer":
          "Retreat nights for Sadhaka and Upasaka tiers are personal. Samrakshak tier nights can be shared with up to two immediate family members per year.",
    },
    {
      "question":
          "Is my recurring contribution tax-exempt under 80G and 501c3?",
      "answer":
          "Yes, Chaturveda Foundation is a registered non-profit. All financial contributions are eligible for tax deductions in India and the US.",
    },
  ];
}
