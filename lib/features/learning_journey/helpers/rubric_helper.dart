// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RubricController extends GetxController {
  static SupabaseClient supabase = Supabase.instance.client;

  RxBool fetchingCompetencices = false.obs;
  List<Competency> competencies = [];

  RxBool fetchingScienceStandard = false.obs;
  List<ScienceStandard> scienceStandards = [];

  RxBool fetchingNonScienceStandard = false.obs;
  List<NonScienceStandard> nonScienceStandards = [];

  RxBool fetchingRubric = false.obs;
  RxList<String> rubrics = <String>[].obs;

  getCompentencies({required int drlid}) async {
    competencies.clear();
    fetchingCompetencices.value = true;
    try {
      final response = await supabase
          .from('integrated_rubrics_dpc')
          .select('dp_competencies(dpc_label, dpc_heading, dpc_description)')
          .eq('drlid', drlid);

      for (var element in response) {
        //print('competencies ${element['dp_competencies']['dpc_heading']}');
        competencies.add(Competency.fromMap(element['dp_competencies']));
      }
    } catch (e) {
      print('error fetching comptencies $e');
    }
    fetchingCompetencices.value = false;
  }

  getScienceStandard({required int drlid}) async {
    scienceStandards.clear();
    fetchingScienceStandard.value = true;
    try {
      final response = await supabase
          .from('district_rubrics_ngss_pes')
          .select('ngss_performance_expectations(label, expectation)')
          .eq('drlid', drlid);
      for (var element in response) {
        print('standard ${element['ngss_performance_expectations']['label']}');
        scienceStandards.add(
          ScienceStandard.fromMap(element['ngss_performance_expectations']),
        );
      }
    } catch (e) {
      print('error fetching science standard $e');
    }
    fetchingScienceStandard.value = false;
  }

  getNonScienceStandard({required int drlid}) async {
    nonScienceStandards.clear();
    fetchingNonScienceStandard.value = true;
    try {
      final response = await supabase
          .from('district_rubrics_p_standards')
          .select(
            'parent_state_standards(standard_label, standard_description)',
          )
          .eq('drlid', drlid);
      print('getNonScienceStandard $response');
      for (var element in response) {
        nonScienceStandards.add(
          NonScienceStandard.fromMap(element['parent_state_standards']),
        );
      }
    } catch (e) {
      print('error fetching non science standard $e');
    }
    fetchingNonScienceStandard.value = false;
  }

  getRubric({required int drlid, required int dplvlid}) async {
    rubrics.clear();
    fetchingRubric.value = true;
    try {
      final response = await supabase
          .from('integrated_rubrics')
          .select('integrated_rubric_description')
          .eq('drlid', drlid)
          .eq('dplvlid', dplvlid);
      for (var element in response) {
        rubrics.add(element['integrated_rubric_description']);
      }
      rubrics.refresh();
      print('rubric $rubrics');
    } catch (e) {
      print('Error fething rubrics $e');
    }
    fetchingRubric.value = false;
  }
}

class Competency {
  final String? dpcLabel;
  final String? dpcHeading;
  final String? dpcDescription;
  Competency({this.dpcLabel, this.dpcHeading, this.dpcDescription});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dpcLabel': dpcLabel,
      'dpcHeading': dpcHeading,
      'dpcDescription': dpcDescription,
    };
  }

  factory Competency.fromMap(Map<String, dynamic> map) {
    return Competency(
      dpcLabel: map['dpc_label'] != null ? map['dpc_label'] as String : null,
      dpcHeading: map['dpc_heading'] != null
          ? map['dpc_heading'] as String
          : null,
      dpcDescription: map['dpc_description'] != null
          ? map['dpc_description'] as String
          : null,
    );
  }
}

class ScienceStandard {
  final String? label;
  final String? expectation;
  ScienceStandard({this.label, this.expectation});

  factory ScienceStandard.fromMap(Map<String, dynamic> map) {
    return ScienceStandard(
      label: map['label'] != null ? map['label'] as String : null,
      expectation: map['expectation'] != null
          ? map['expectation'] as String
          : null,
    );
  }
}

class NonScienceStandard {
  final String? label;
  final String? description;
  NonScienceStandard({this.label, this.description});

  factory NonScienceStandard.fromMap(Map<String, dynamic> map) {
    return NonScienceStandard(
      label: map['standard_label'] != null
          ? map['standard_label'] as String
          : null,
      description: map['standard_description'] != null
          ? map['standard_description'] as String
          : null,
    );
  }
}
