import 'package:demoaiemo/pages/activity_page.dart';
import 'package:flutter/material.dart';

class SuggestionToggles extends StatefulWidget {
  final List<String> modelBasedSuggestions;
  final List<String> myDecisionSuggestions;
  final List<String> mostChosenSuggestions;

  SuggestionToggles({
    required this.modelBasedSuggestions,
    required this.myDecisionSuggestions,
    required this.mostChosenSuggestions,
  });

  @override
  _SuggestionTogglesState createState() => _SuggestionTogglesState();
}

class _SuggestionTogglesState extends State<SuggestionToggles> {
  bool _modelBasedExpanded = false;
  bool _myDecisionExpanded = false;
  bool _mostChosenExpanded = false;

  void _navigateToActivityPage(String suggestion) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivityPage(suggestion: suggestion, mood: "happy"), // Example mood
      ),
    );
  }

  Widget _buildSuggestionList(List<String> suggestions) {
    return Column(
      children: suggestions.map((suggestion) {
        return ListTile(
          title: Text(suggestion),
          onTap: () => _navigateToActivityPage(suggestion),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpansionTile(
            title: Text('Model Based Suggestions'),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _modelBasedExpanded = expanded;
              });
            },
            children: _modelBasedExpanded 
              ? [_buildSuggestionList(widget.modelBasedSuggestions)] 
              : [],
          ),
          ExpansionTile(
            title: Text('My Decision Based Suggestions'),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _myDecisionExpanded = expanded;
              });
            },
            children: _myDecisionExpanded 
              ? [_buildSuggestionList(widget.myDecisionSuggestions)] 
              : [],
          ),
          ExpansionTile(
            title: Text('Most Chosen Suggestions'),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _mostChosenExpanded = expanded;
              });
            },
            children: _mostChosenExpanded 
              ? [_buildSuggestionList(widget.mostChosenSuggestions)] 
              : [],
          ),
        ],
      ),
    );
  }
}
