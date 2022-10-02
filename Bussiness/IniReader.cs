using System.Runtime.InteropServices;
using System.Text;

namespace Bussiness
{
    public class IniReader
    {
        private string FilePath;

        public IniReader(string _FilePath)
        {
			FilePath = _FilePath;
        }

        public string GetIniString(string Section, string Key)
        {
			StringBuilder retVal = new StringBuilder(2550);
			GetPrivateProfileString(Section, Key, "", retVal, 2550, FilePath);
			return retVal.ToString();
        }

        [DllImport("kernel32")]
		private static extern int GetPrivateProfileString(string section, string key, string def, StringBuilder retVal, int size, string filePath);
    }
}
