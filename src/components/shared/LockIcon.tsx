import { hp, wp } from "@/helpers/ruler";
import Svg, { Rect, Path } from "react-native-svg";

type LockIconProps = {
  style?: object;
  color?: string;
  width?: number;
  height?: number;
};
const LockIcon = ({ style, color, width, height }: LockIconProps) => (
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
    className="feather feather-lock"
    style={style}
  >
    <Rect x={3} y={11} width={18} height={11} rx={2} ry={2} />
    <Path d="M7 11V7a5 5 0 0 1 10 0v4" />
  </Svg>
);
export default LockIcon;
