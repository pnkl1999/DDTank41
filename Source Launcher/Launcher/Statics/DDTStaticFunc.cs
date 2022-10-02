using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Windows.Forms;
using Launcher.Models;
using Launcher.Properties;
using Properties;

namespace Launcher.Statics
{
	public class DDTStaticFunc
	{
		[CompilerGenerated]
		private static string string_0;

		[CompilerGenerated]
		private static string string_1;

		[CompilerGenerated]
		private static string string_2;

		[CompilerGenerated]
		private static string string_3;

		[CompilerGenerated]
		private static int int_0;

		[CompilerGenerated]
		private static string string_4;

		[CompilerGenerated]
		private static bool isDebug;

		[CompilerGenerated]
		private static string string_5;

		private static List<LogModel> list_0;

		private static List<LogModel> list_1;

		[CompilerGenerated]
		private static int int_1;

		[CompilerGenerated]
		private static string string_6;

		[CompilerGenerated]
		private static string string_7;

		[CompilerGenerated]
		private static string string_8;

		internal static DDTStaticFunc xvso0kkwdl00MfWGkY1;

		public static string MAC_Address
		{
			[CompilerGenerated]
			get
			{
				return string_0;
			}
			[CompilerGenerated]
			set
			{
				string_0 = value;
			}
		}

		public static string Host
		{
			[CompilerGenerated]
			get
			{
				return string_1;
			}
			[CompilerGenerated]
			set
			{
				string_1 = value;
			}
		}

		public static string LoginUrl
		{
			[CompilerGenerated]
			get
			{
				return string_2;
			}
			[CompilerGenerated]
			set
			{
				string_2 = value;
			}
		}

		public static string ServerName
		{
			[CompilerGenerated]
			get
			{
				return string_3;
			}
			[CompilerGenerated]
			set
			{
				string_3 = value;
			}
		}

		public static int IsPlaying
		{
			[CompilerGenerated]
			get
			{
				return int_0;
			}
			[CompilerGenerated]
			set
			{
				int_0 = value;
			}
		}

		public static string Url
		{
			[CompilerGenerated]
			get
			{
				return string_4;
			}
			[CompilerGenerated]
			set
			{
				string_4 = value;
			}
		}

		public static bool IsDebug
		{
			[CompilerGenerated]
			get
			{
				return isDebug;
			}
			[CompilerGenerated]
			set
			{
				isDebug = value;
			}
		}

		public static string FlashVars
		{
			[CompilerGenerated]
			get
			{
				return string_5;
			}
			[CompilerGenerated]
			set
			{
				string_5 = value;
			}
		}

		public static int ButtomStatus
		{
			[CompilerGenerated]
			get
			{
				return int_1;
			}
			[CompilerGenerated]
			set
			{
				int_1 = value;
			}
		}

		public static string DefaultOcx
		{
			[CompilerGenerated]
			get
			{
				return string_6;
			}
			[CompilerGenerated]
			set
			{
				string_6 = value;
			}
		}

		public static string DefaulAccount
		{
			[CompilerGenerated]
			get
			{
				return string_7;
			}
			[CompilerGenerated]
			set
			{
				string_7 = value;
			}
		}

		public static string DefaultPassword
		{
			[CompilerGenerated]
			get
			{
				return string_8;
			}
			[CompilerGenerated]
			set
			{
				string_8 = value;
			}
		}

		public static void Init(bool printMac = false)
		{
			SetUrl(Resources.Host, "", "");
			if (isDebug)
			{
				SetUrl(Resources.LocalHost, "", "");
			}
			if (printMac)
			{
				using StreamWriter streamWriter = new StreamWriter(Application.StartupPath + "\\FingerPrint.txt", append: false);
				streamWriter.WriteLine($"{DateTime.Now:yyyy-MM-dd HH:mm:ss} FingerPrint");
				streamWriter.WriteLine("    " + string_0);
			}
		}

		public static void SetUrl(string url, string acc, string pass)
		{
			Host = url;
			LoginUrl = url + Resources.Login;
			DefaulAccount = acc;
			DefaultPassword = pass;
		}

		public static string GetLocalIPAddress()
		{
			IPAddress[] addressList = Dns.GetHostEntry(Dns.GetHostName()).AddressList;
			int num = 0;
			IPAddress iPAddress;
			while (true)
			{
				if (num < addressList.Length)
				{
					iPAddress = addressList[num];
					if (iPAddress.AddressFamily == AddressFamily.InterNetwork)
					{
						break;
					}
					num++;
					continue;
				}
				return "0.0.0.0";
			}
			return iPAddress.ToString();
		}

		public static void AddUpdateLogs(string title, string content, bool writeLog = false)
		{
			if (isDebug)
			{
				lock (list_1)
				{
					list_1.Add(new LogModel
					{
						Title = title,
						Content = content
					});
				}
				try
				{
					using StreamWriter streamWriter = new StreamWriter(Application.StartupPath + "\\Debug.txt", append: false);
					foreach (LogModel item in list_1)
					{
						streamWriter.WriteLine($"{item.AddTime:yyyy-MM-dd HH:mm:ss} {item.Title}");
						streamWriter.WriteLine("   " + item.Content);
					}
				}
				catch
				{
				}
			}
			else if (!writeLog)
			{
				if (!string.IsNullOrEmpty(LoginMgr.Username))
				{
					string value = Util.MD5(LoginMgr.Username + LoginMgr.Password + Resources.PublicKey);
					string plainText = $"{DateTime.Now:yyyy-MM-dd HH:mm:ss} {title}, Content:{content}";
					NameValueCollection param = new NameValueCollection
					{
						{
							"u",
							LoginMgr.Username
						},
						{
							"p",
							LoginMgr.Password
						},
						{
							"d",
							Util.Base64Encode(plainText)
						},
						{ "key", value }
					};
					ControlMgr.Post(string_1 + Resources.PostError, param);
				}
			}
			else
			{
				lock (list_0)
				{
					list_0.Add(new LogModel
					{
						Title = title,
						Content = content
					});
				}
			}
		}

		public static DataTable ToDataTable<T>(IList<T> data)
		{
			FieldInfo[] fields = typeof(T).GetFields(BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic);
			DataTable dataTable = new DataTable();
			foreach (FieldInfo fieldInfo in fields)
			{
				dataTable.Columns.Add(fieldInfo.Name, fieldInfo.FieldType);
			}
			object[] array = new object[fields.Length];
			foreach (T datum in data)
			{
				for (int j = 0; j < array.Length; j++)
				{
					array[j] = fields[j].GetValue(datum);
				}
				dataTable.Rows.Add(array);
			}
			return dataTable;
		}

		public static List<LogModel> AllLog()
		{
			List<LogModel> list = new List<LogModel>();
			list.AddRange(list_0);
			return list;
		}

		public static DataTable GetAllLog()
		{
			return ToDataTable(AllLog());
		}

		static DDTStaticFunc()
		{
			list_0 = new List<LogModel>();
			list_1 = new List<LogModel>();
			string_6 = "winfl";
		}

		internal static bool A45kW7k3Z9dMKSqFEH1()
		{
			return xvso0kkwdl00MfWGkY1 == null;
		}

		internal static void PHaVFxCC4I7dG5cKt3T()
		{
		}

		internal static void Itktv7CTkxWKOZEnqwR()
		{
		}

		internal static void zgXvEUCvB4F1qiHa4g5()
		{
		}
	}
}
