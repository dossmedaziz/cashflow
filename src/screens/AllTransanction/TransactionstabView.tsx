import useTransactionStore from "@/stores/useTransactionStore";
import * as React from "react";
import { Text, View, useWindowDimensions } from "react-native";
import { TabView, SceneMap, TabBar } from "react-native-tab-view";

import ExpenseTabView from "./TransactionstabView";
import IncomeTabView from "./IncomeTabView";

const renderScene = SceneMap({
  first: IncomeTabView,
  second: ExpenseTabView,
});

export default function TransactionstabView() {
  const layout = useWindowDimensions();

  const [index, setIndex] = React.useState(0);
  const routes = [
    { key: "first", title: "Incomes" },
    { key: "second", title: "Expenses" },
  ];

  return (
    <TabView
      navigationState={{ index, routes }}
      renderScene={renderScene}
      onIndexChange={setIndex}
      initialLayout={{ width: layout.width }}
      pagerStyle={{ backgroundColor: "white" }}
      lazy={true}
      renderTabBar={(props) => (
        <TabBar
          {...props}
          indicatorStyle={{ backgroundColor: "black" }}
          style={{ backgroundColor: "white" }}
          activeColor={"black"}
          inactiveColor={"grey"}
        />
      )}
    />
  );
}
