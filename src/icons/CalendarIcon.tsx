import * as React from "react";
import Svg, { Rect, Line } from "react-native-svg";
import { hp, wp } from "@/helpers/ruler";
type CalendarIconType = {
  style?: object;
  color?: string;
  width?: number;
  height?: number;
};
const CalendarIcon = ({ style, color, width, height }: CalendarIconType) => (
  <Svg
    xmlns="http://www.w3.org/2000/svg"
    width={width || wp(7)}
    height={height || hp(4)}
    viewBox="0 0 24 24"
    fill="none"
    stroke={color || "#000000"}
    strokeWidth={2}
    strokeLinecap="round"
    strokeLinejoin="round"
    className="feather feather-calendar"
    style={style}
  >
    <Rect x={3} y={4} width={18} height={18} rx={2} ry={2} />
    <Line x1={16} y1={2} x2={16} y2={6} />
    <Line x1={8} y1={2} x2={8} y2={6} />
    <Line x1={3} y1={10} x2={21} y2={10} />
  </Svg>
);
export default CalendarIcon;
