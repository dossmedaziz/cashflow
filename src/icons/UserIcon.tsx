import { hp, wp } from "@/helpers/ruler";
import Svg, { Path, Circle } from "react-native-svg";

type UserIconProps = {
  style?: object;
  color?: string;
  width?: number;
  height?: number;
};

const UserIcon = ({ style, color, width, height }: UserIconProps) => (
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
    className="feather feather-user"
    style={style}
  >
    <Path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
    <Circle cx={12} cy={7} r={4} />
  </Svg>
);
export default UserIcon;
