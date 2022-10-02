namespace SqlDataProvider.Data
{
    public class AreaConfigInfo
    {
        public int AreaID { get; set; }

        public string AreaServer { get; set; }

        public string AreaName { get; set; }

        public string DataSource { get; set; }

        public string Catalog { get; set; }

        public string UserID { get; set; }

        public string Password { get; set; }

        public string RequestUrl { get; set; }

        public bool CrossChatAllow { get; set; }

        public bool CrossPrivateChat { get; set; }

        public string Version { get; set; }
    }
}
