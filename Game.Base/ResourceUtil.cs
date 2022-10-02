using System.IO;
using System.Reflection;

namespace Game.Base
{
    public class ResourceUtil
    {
        public static void ExtractResource(string fileName, Assembly assembly)
        {
			ExtractResource(fileName, fileName, assembly);
        }

        public static void ExtractResource(string resourceName, string fileName, Assembly assembly)
        {
			FileInfo info = new FileInfo(fileName);
			if (!info.Directory.Exists)
			{
				info.Directory.Create();
			}
			using StreamReader reader = new StreamReader(GetResourceStream(resourceName, assembly));
			using StreamWriter writer = new StreamWriter(File.Create(fileName));
			writer.Write(reader.ReadToEnd());
        }

        public static Stream GetResourceStream(string fileName, Assembly assem)
        {
			fileName = fileName.ToLower();
			string[] manifestResourceNames = assem.GetManifestResourceNames();
			string[] array = manifestResourceNames;
			foreach (string str in array)
			{
				if (str.ToLower().EndsWith(fileName))
				{
					return assem.GetManifestResourceStream(str);
				}
			}
			return null;
        }
    }
}
