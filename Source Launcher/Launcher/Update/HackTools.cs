using System.Diagnostics;

namespace Launcher.Update
{
	public class HackTools
	{
		private string[] string_0 = new string[11]
		{
			"inject", "cheatengine", "cheat", "memoryview", "memview", "memorydump", "memorydumper", "ida", "ffdec", "jpexs",
			"packet"
		};

		private static HackTools BL9UjlWM5u0KfC90j4J;

		public bool IsMatch(string data)
		{
			string[] array = string_0;
			int num = 0;
			while (true)
			{
				if (num < array.Length)
				{
					string value = array[num];
					if (data.ToLower().Contains(value))
					{
						break;
					}
					num++;
					continue;
				}
				return false;
			}
			return true;
		}

		public string FindHack()
		{
			Process[] processes = Process.GetProcesses();
			foreach (Process process in processes)
			{
				if (IsMatch(process.ProcessName.Replace(" ", "")))
				{
					return process.ProcessName;
				}
			}
			return "";
		}

		internal static void kccxN3W18uiuNFoW57p()
		{
		}

		internal static bool P68L4uWb5RiPfX1nYJq()
		{
			return BL9UjlWM5u0KfC90j4J == null;
		}

		internal static void svx3JtWHsnYgEIL5Nve()
		{
		}
	}
}
