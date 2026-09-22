/**
 * Research Novel Framework
 * Research Event Listeners
 *
 * ゲームイベントを受け取り、
 * Event Log・Answer Store・ResearchStorageへ記録する。
 */

import eventBus from "../core/event-bus.js";
import { EventType } from "../core/types.js";
import logger from "./logger.js";
import answerStore from "./answer-store.js";
import researchStorage from "./research-storage.js";
import researchDispatcher from "./research-dispatcher.js";
import config from "../core/config.js";
import { createTimeContext } from "./time-context.js";
let registered = false;
let dispatchRequested = false;

async function autoDispatchResearchRecords() {
  if (!config.STORAGE.SEND_TO_SPREADSHEET) {
    return;
  }

  dispatchRequested = true;

  if (researchDispatcher.getStatus().isDispatching) {
    return;
  }

  while (dispatchRequested) {
    dispatchRequested = false;

    try {
      const result = await researchDispatcher.sendAll();

      if (!result.success && result.status !== "busy") {
        console.warn(
          "RNF Research Dispatcher: 自動送信を完了できませんでした。",
          result
        );
        return;
      }
    } catch (error) {
      console.error(
        "RNF Research Dispatcher: 自動送信中にエラーが発生しました。",
        error
      );
      return;
    }

    if (researchStorage.getQueueCount() > 0) {
      dispatchRequested = true;
    }
  }
}

/**
 * 研究用イベントリスナーを登録する。
 */
export function registerResearchListeners() {
  if (registered) {
    return;
  }

  registered = true;

  eventBus.on(EventType.CHOICE_SELECTED, (data) => {
    const timeContext = createTimeContext();
    const eventLog = logger.logEvent({
      timeContext,
      eventType: EventType.CHOICE_SELECTED,
      data,
    });

    const answer = answerStore.saveChoice({
      timeContext,
      questionId: data.questionId,
      choiceId: data.choiceId,
      choiceText: data.choiceText ?? null,
    });

    if (eventLog) {
      researchStorage.enqueueEvent(eventLog);
    }

    if (answer) {
      researchStorage.enqueueAnswer(answer);
    }

    autoDispatchResearchRecords();
  });

  eventBus.on(EventType.TEXT_INPUT_SUBMITTED, (data) => {
    const timeContext = createTimeContext();
    const eventLog = logger.logEvent({
      timeContext,
      eventType: EventType.TEXT_INPUT_SUBMITTED,
      data,
    });

    const answer = answerStore.saveTextInput({
      timeContext,
      inputId: data.inputId,
      inputText: data.inputText,
    });

    if (eventLog) {
      researchStorage.enqueueEvent(eventLog);
    }

    if (answer) {
      researchStorage.enqueueAnswer(answer);
    }

    autoDispatchResearchRecords();
  });
}