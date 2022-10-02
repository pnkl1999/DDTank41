namespace SqlDataProvider.Data
{
    public class MissionInfo
    {
        private int m_delay;

        private string m_description;

        private string m_failure;

        private int m_id;

        private int m_incrementDelay;

        private string m_name;

        private int m_param1;

        private int m_param2;

        private int m_param3;

        private int m_param4;

        private string m_script;

        private string m_success;

        private string m_title;

        private int m_totalCount;

        private int m_totalTurn;

        public int Delay
        {
			get
			{
				return m_delay;
			}
			set
			{
				m_delay = value;
			}
        }

        public string Description
        {
			get
			{
				return m_description;
			}
			set
			{
				m_description = value;
			}
        }

        public string Failure
        {
			get
			{
				return m_failure;
			}
			set
			{
				m_failure = value;
			}
        }

        public int Id
        {
			get
			{
				return m_id;
			}
			set
			{
				m_id = value;
			}
        }

        public int IncrementDelay
        {
			get
			{
				return m_incrementDelay;
			}
			set
			{
				m_incrementDelay = value;
			}
        }

        public string Name
        {
			get
			{
				return m_name;
			}
			set
			{
				m_name = value;
			}
        }

        public int Param1
        {
			get
			{
				return m_param1;
			}
			set
			{
				m_param1 = value;
			}
        }

        public int Param2
        {
			get
			{
				return m_param2;
			}
			set
			{
				m_param2 = value;
			}
        }

        public int Param3
        {
			get
			{
				return m_param3;
			}
			set
			{
				m_param3 = value;
			}
        }

        public int Param4
        {
			get
			{
				return m_param4;
			}
			set
			{
				m_param4 = value;
			}
        }

        public string Script
        {
			get
			{
				return m_script;
			}
			set
			{
				m_script = value;
			}
        }

        public string Success
        {
			get
			{
				return m_success;
			}
			set
			{
				m_success = value;
			}
        }

        public string Title
        {
			get
			{
				return m_title;
			}
			set
			{
				m_title = value;
			}
        }

        public int TotalCount
        {
			get
			{
				return m_totalCount;
			}
			set
			{
				m_totalCount = value;
			}
        }

        public int TotalTurn
        {
			get
			{
				return m_totalTurn;
			}
			set
			{
				m_totalTurn = value;
			}
        }
        private bool m_tryAgain;

        public bool TryAgain
        {
            get { return m_tryAgain; }
            set { m_tryAgain = value; }
        }

        private int m_tryAgainCost;

        public int TryAgainCost
        {
            get { return m_tryAgainCost; }
            set { m_tryAgainCost = value; }
        }


        public MissionInfo()
        {
			m_param1 = -1;
			m_param2 = -1;
			m_param3 = -1;
			m_param4 = -1;
        }

        public MissionInfo(int id, string name, string key, string description, int totalCount, int totalTurn, int initDelay, int delay, string title, int param1, int param2)
        {
			m_id = id;
			m_name = name;
			m_description = description;
			m_failure = key;
			m_totalCount = totalCount;
			m_totalTurn = totalTurn;
			m_incrementDelay = initDelay;
			m_delay = delay;
			m_title = title;
			m_param1 = param1;
			m_param2 = param2;
			m_param3 = -1;
			m_param4 = -1;
        }
    }
}
