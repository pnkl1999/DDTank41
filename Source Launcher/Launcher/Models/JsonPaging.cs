using System.Data;

namespace Launcher.Models
{
	public class JsonPaging
	{
		private int m_totalRecord;

		private DataTable m_dataTable;

		public int TotalRecord
		{
			get
			{
				return m_totalRecord;
			}
			set
			{
				m_totalRecord = value;
			}
		}

		public DataTable Data
		{
			get
			{
				return m_dataTable;
			}
			set
			{
				m_dataTable = value;
			}
		}
	}
}
