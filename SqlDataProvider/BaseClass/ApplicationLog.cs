using System.Diagnostics;

namespace SqlDataProvider.BaseClass
{
    public static class ApplicationLog
    {
        public static void WriteError(string message)
        {
			WriteLog(TraceLevel.Error, message);
        }

        private static void WriteLog(TraceLevel level, string messageText)
        {
			try
			{
				EventLogEntryType type = ((level != TraceLevel.Error) ? EventLogEntryType.Error : EventLogEntryType.Error);
				string str = "Application";
				if (!EventLog.SourceExists(str))
				{
					EventLog.CreateEventSource(str, "BIZ");
				}
				new EventLog(str, ".", str).WriteEntry(messageText, type);
			}
			catch
			{
			}
        }
    }
}
