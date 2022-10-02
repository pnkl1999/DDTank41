using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using Launcher.Properties;
using Newtonsoft.Json;
using Properties;

namespace Launcher.Statics
{
	public class LoginMgr
	{
		public static string UserPath;

		private static Dictionary<string, string> dictionary_0;

		private static Dictionary<string, string> dictionary_1;

		public static bool IsLogin;

		public static string Username;

		public static string Password;

		public static string VIPLevel;


		public static void AddAccount(string username, string password)
		{
			if (dictionary_1.ContainsKey(username))
			{
				dictionary_1[username] = password;
			}
			else
			{
				dictionary_1.Add(username, password);
			}
		}

		public static void Save()
		{
			string text = "";
			try
			{
				if (!Directory.Exists(UserPath))
				{
					Directory.CreateDirectory(UserPath);
				}
				text = JsonConvert.SerializeObject(dictionary_1);
				byte[] array = RC4.Encrypt(Encoding.UTF8.GetBytes(Resources.LocalKey), Encoding.UTF8.GetBytes(text));
				using FileStream fileStream = new FileStream(UserPath + Resources.LogFile, FileMode.Create, FileAccess.Write);
				fileStream.Write(array, 0, array.Length);
			}
			catch (Exception ex)
			{
				DDTStaticFunc.AddUpdateLogs("Exception 13" + ex.Message, ex.ToString());
			}
		}

		public static string GetSavePassword(string username)
		{
			if (dictionary_1.ContainsKey(username))
			{
				return dictionary_1[username];
			}
			return "";
		}

		public static void Login(string username, string password)
		{
			IsLogin = true;
			Username = username;
			Password = password;
			if (dictionary_0.ContainsKey(username))
			{
				dictionary_0[username] = password;
			}
			else
			{
				dictionary_0.Add(username, password);
			}
		}

		static LoginMgr()
		{
			UserPath = Path.GetTempPath() + Util.MD5(Resources.Host);
			dictionary_0 = new Dictionary<string, string>();
			dictionary_1 = new Dictionary<string, string>();
			IsLogin = false;
			Username = null;
			Password = null;
			VIPLevel = "0";
		}
	}
}
