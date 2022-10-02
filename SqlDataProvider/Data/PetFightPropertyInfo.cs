namespace SqlDataProvider.Data
{
    public class PetFightPropertyInfo
    {
        private int _Agility;

        private int _Attack;

        private int _Blood;

        private int _Defence;

        private int _Exp;

        private int _ID;

        private int _Lucky;

        public int Agility
        {
			get
			{
				return _Agility;
			}
			set
			{
				_Agility = value;
			}
        }

        public int Attack
        {
			get
			{
				return _Attack;
			}
			set
			{
				_Attack = value;
			}
        }

        public int Blood
        {
			get
			{
				return _Blood;
			}
			set
			{
				_Blood = value;
			}
        }

        public int Defence
        {
			get
			{
				return _Defence;
			}
			set
			{
				_Defence = value;
			}
        }

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

        public int ID
        {
			get
			{
				return _ID;
			}
			set
			{
				_ID = value;
			}
        }

        public int Lucky
        {
			get
			{
				return _Lucky;
			}
			set
			{
				_Lucky = value;
			}
        }
    }
}
