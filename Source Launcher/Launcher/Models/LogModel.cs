using System;
using System.Runtime.CompilerServices;

namespace Launcher.Models
{
	public class LogModel
	{
		[CompilerGenerated]
		private string string_0;

		[CompilerGenerated]
		private string string_1;

		[CompilerGenerated]
		private string string_2;

		[CompilerGenerated]
		private DateTime dateTime_0;

		private static LogModel WT3svVWs93SVUDQD6y5;

		public string ID
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

		public string Title
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

		public string Content
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

		public DateTime AddTime
		{
			[CompilerGenerated]
			get
			{
				return dateTime_0;
			}
			[CompilerGenerated]
			set
			{
				dateTime_0 = value;
			}
		}

		public LogModel()
		{
			AddTime = DateTime.Now;
			ID = Guid.NewGuid().ToString();
		}

		internal static void hvCMaDWLJ8gBRl05Vqo()
		{
		}

		internal static void shM8buWgPVjtSgaeK2h()
		{
		}

		internal static bool cSGswyWVsRY9njlTfyQ()
		{
			return WT3svVWs93SVUDQD6y5 == null;
		}
	}
}
