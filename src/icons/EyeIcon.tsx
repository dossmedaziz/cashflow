import { hp, wp } from "@/helpers/ruler";
import Svg, { Path, Circle } from "react-native-svg";

type EyeIconProps = {
  style?: object;
  color?: string;
  width?: number;
  height?: number;
};
const EyeIcon = ({ style, color, width, height }: EyeIconProps) => (
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
    className="feather feather-eye"
    style={style}
  >
    <Path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
    <Circle cx={12} cy={12} r={3} />
  </Svg>
);
export default EyeIcon;
