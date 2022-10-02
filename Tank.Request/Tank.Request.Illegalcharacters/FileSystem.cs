using System.Collections;
using System.IO;
using System.Text;

namespace Tank.Request.Illegalcharacters
{
	public class FileSystem
	{
		public ArrayList contentList = new ArrayList();

		private FileSystemWatcher fileWatcher = new FileSystemWatcher();

		private string filePath = string.Empty;

		private string fileDirectory = string.Empty;

		private string fileType = string.Empty;

		public FileSystem(string Path, string Directory, string Type)
		{
			initContent(Path);
			initFileWatcher(Directory, Type);
		}

		private void initContent(string Path)
		{
			if (!File.Exists(Path))
			{
				return;
			}
			filePath = Path;
			StreamReader streamReader = new StreamReader(Path, Encoding.GetEncoding("GB2312"));
			string str = "";
			if (contentList.Count > 0)
			{
				contentList.Clear();
			}
			while (str != null)
			{
				str = streamReader.ReadLine();
				if (!string.IsNullOrEmpty(str))
				{
					contentList.Add(str);
				}
			}
			if (str == null)
			{
				streamReader.Close();
			}
		}

		private void initFileWatcher(string directory, string type)
		{
			if (Directory.Exists(directory))
			{
				fileDirectory = directory;
				fileType = type;
				fileWatcher.Path = directory;
				fileWatcher.Filter = type;
				fileWatcher.NotifyFilter = NotifyFilters.FileName | NotifyFilters.LastWrite | NotifyFilters.LastAccess;
				fileWatcher.EnableRaisingEvents = true;
				fileWatcher.Changed += OnChanged;
				fileWatcher.Renamed += OnRenamed;
			}
		}

		public bool checkIllegalChar(string strRegName)
		{
			bool flag = false;
			if (!string.IsNullOrEmpty(strRegName))
			{
				flag = checkChar(strRegName);
			}
			return flag;
		}

		private bool checkChar(string strRegName)
		{
			bool flag = false;
			foreach (string content in contentList)
			{
				if (!content.StartsWith("GM"))
				{
					string text = content;
					for (int i = 0; i < text.Length; i++)
					{
						if (strRegName.Contains(text[i].ToString()))
						{
							flag = true;
							break;
						}
					}
					if (flag)
					{
						return flag;
					}
					continue;
				}
				string str1 = content;
				char[] chArray = new char[1]
				{
					'|'
				};
				string[] array = str1.Split(chArray);
				foreach (string str2 in array)
				{
					if (strRegName.Contains(str2))
					{
						flag = true;
						break;
					}
				}
				if (flag)
				{
					return flag;
				}
			}
			return flag;
		}

		private void OnChanged(object source, FileSystemEventArgs e)
		{
			UpdataContent();
		}

		private void UpdataContent()
		{
			initContent(filePath);
		}

		private static void OnRenamed(object source, RenamedEventArgs e)
		{
		}
	}
}
