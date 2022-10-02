namespace SqlDataProvider.Data
{
    public class PetStarExpInfo
    {
		public int ID { get; set; }

		private int _Exp;

        private int _NewID;

        private int _OldID;

        public int Exp
        {
			get
			{
				return _Exp;
			}
			set
			{
				_Exp = value;
			}
        }

        public int NewID
        {
			get
			{
				return _NewID;
			}
			set
			{
				_NewID = value;
			}
        }

        public int OldID
        {
			get
			{
				return _OldID;
			}
			set
			{
				_OldID = value;
			}
        }
    }
}
