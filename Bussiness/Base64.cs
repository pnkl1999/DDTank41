namespace Bussiness
{
    public class Base64
    {
        private static readonly string BASE64_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

        public static string encodeByteArray(byte[] param1)
        {
            string _loc_2 = "";
            byte[] _loc_3 = new byte[4];
            for (int i = 0; i < param1.Length; i += 4)
            {
                byte[] _loc_4 = new byte[3];
                for (int _loc_5 = 0; _loc_5 < param1.Length; _loc_5++)
                {
                    if (_loc_5 < 3)
                    {
                        if (_loc_5 + i > param1.Length)
                        {
                            break;
                        }
                        _loc_4[_loc_5] = param1[_loc_5 + i];
                    }
                }
                _loc_3[0] = (byte)((_loc_4[0] & 0xFC) >> 2);
                _loc_3[1] = (byte)(((_loc_4[0] & 3) << 4) | (_loc_4[1] >> 4));
                _loc_3[2] = (byte)(((_loc_4[1] & 0xF) << 2) | (_loc_4[2] >> 6));
                _loc_3[3] = (byte)(_loc_4[2] & 0x3Fu);
                for (int _loc_6 = _loc_4.Length; _loc_6 < 3; _loc_6++)
                {
                    _loc_3[_loc_6 + 1] = 64;
                }
                for (int _loc_7 = 0; _loc_7 < _loc_3.Length; _loc_7++)
                {
                    _loc_2 += BASE64_CHARS.Substring(_loc_3[_loc_7], 1);
                }
            }
            _loc_2 = _loc_2.Substring(0, param1.Length - 1);
            return _loc_2 + "=";
        }

        public static byte[] decodeToByteArray2(string param1)
        {
            byte[] _loc_2 = new byte[param1.Length];
            byte[] _loc_3 = new byte[4];
            for (int _loc_4 = 0; _loc_4 < param1.Length; _loc_4 += 4)
            {
                int _loc_5 = 0;
                int index;
                do
                {
                    index = _loc_4 + _loc_5;
                    if (_loc_5 < 4)
                    {
                        _loc_3[_loc_5] = (byte)BASE64_CHARS.IndexOf(param1.Substring(index, 1));
                    }
                    _loc_5++;
                }
                while (index < param1.Length);
                for (int _loc_6 = 0; _loc_6 < _loc_3.Length && _loc_3[_loc_6] != 64; _loc_6++)
                {
                    _loc_2[_loc_4 + _loc_6] = _loc_3[_loc_6];
                }
            }
            return _loc_2;
        }

        public static byte[] decodeToByteArray(string param1)
        {
            byte[] _loc_2 = new byte[param1.Length];
            byte[] _loc_3 = new byte[4];
            byte[] _loc_4 = new byte[3];
            for (int _loc_5 = 0; _loc_5 < param1.Length; _loc_5 += 4)
            {
                int _loc_6 = 0;
                int index;
                do
                {
                    index = _loc_5 + _loc_6;
                    if (_loc_6 < 4)
                    {
                        _loc_3[_loc_6] = (byte)BASE64_CHARS.IndexOf(param1.Substring(index, 1));
                    }
                    _loc_6++;
                }
                while (index < param1.Length);
                _loc_4[0] = (byte)((_loc_3[0] << 2) + ((_loc_3[1] & 0x30) >> 4));
                _loc_4[1] = (byte)(((_loc_3[1] & 0xF) << 4) + ((_loc_3[2] & 0x3C) >> 2));
                _loc_4[2] = (byte)(((_loc_3[2] & 3) << 6) + _loc_3[3]);
                for (int _loc_7 = 0; _loc_7 < _loc_4.Length && _loc_3[_loc_7 + 1] != 64; _loc_7++)
                {
                    _loc_2[_loc_5 + _loc_7] = _loc_4[_loc_7];
                }
            }
            return _loc_2;
        }
    }
}
