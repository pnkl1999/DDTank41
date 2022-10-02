namespace SqlDataProvider.Data
{
    public class ServerEventInfo
    {
        private int id;

        private string name;

        private string value;

        public int ID
        {
			get
			{
				return id;
			}
			set
			{
				id = value;
			}
        }

        public string Name
        {
			get
			{
				return name;
			}
			set
			{
				name = value;
			}
        }

        public string Value
        {
			get
			{
				return value;
			}
			set
			{
				this.value = value;
			}
        }
    }
}
