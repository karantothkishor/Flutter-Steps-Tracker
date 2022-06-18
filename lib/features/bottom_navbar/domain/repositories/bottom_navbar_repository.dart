import 'package:dartz/dartz.dart';
import 'package:flutter_steps_tracker/core/data/error/failures/application_failure.dart';
import 'package:flutter_steps_tracker/features/bottom_navbar/data/models/exchange_history_model.dart';
import 'package:flutter_steps_tracker/features/bottom_navbar/data/models/reward_model.dart';

abstract class BottomNavbarRepository {
  Stream<List<RewardModel>> rewardsStream();

  Future<Either<Failure, Stream<List<ExchangeHistoryModel>>>>
      exchangesHistoryStream();

  Future<Either<Failure, bool>> setExchangeHistory(
      ExchangeHistoryModel exchangeHistory);
}
