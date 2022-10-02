namespace SqlDataProvider.Data
{
    public class EatPetsInfo : DataObject
    {
        private int _iD;

        private int _userID;

        private int _weaponExp;

        private int _weaponLevel;

        private int _clothesExp;

        private int _clothesLevel;

        private int _hatExp;

        private int _hatLevel;

        public int ID
        {
			get
			{
				return _iD;
			}
			set
			{
				_iD = value;
				_isDirty = true;
			}
        }

        public int UserID
        {
			get
			{
				return _userID;
			}
			set
			{
				_userID = value;
				_isDirty = true;
			}
        }

        public int weaponExp
        {
			get
			{
				return _weaponExp;
			}
			set
			{
				_weaponExp = value;
				_isDirty = true;
			}
        }

        public int weaponLevel
        {
			get
			{
				return _weaponLevel;
			}
			set
			{
				_weaponLevel = value;
				_isDirty = true;
			}
        }

        public int clothesExp
        {
			get
			{
				return _clothesExp;
			}
			set
			{
				_clothesExp = value;
				_isDirty = true;
			}
        }

        public int clothesLevel
        {
			get
			{
				return _clothesLevel;
			}
			set
			{
				_clothesLevel = value;
				_isDirty = true;
			}
        }

        public int hatExp
        {
			get
			{
				return _hatExp;
			}
			set
			{
				_hatExp = value;
				_isDirty = true;
			}
        }

        public int hatLevel
        {
			get
			{
				return _hatLevel;
			}
			set
			{
				_hatLevel = value;
				_isDirty = true;
			}
        }
    }
}
