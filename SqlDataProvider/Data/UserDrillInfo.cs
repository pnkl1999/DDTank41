namespace SqlDataProvider.Data
{
    public class UserDrillInfo : DataObject
    {
        private int _beadPlace;

        private int _drillPlace;

        private int _holeExp;

        private int _holeLv;

        private int _userID;

        public int BeadPlace
        {
			get
			{
				return _beadPlace;
			}
			set
			{
				_beadPlace = value;
				_isDirty = true;
			}
        }

        public int DrillPlace
        {
			get
			{
				return _drillPlace;
			}
			set
			{
				_drillPlace = value;
				_isDirty = true;
			}
        }

        public int HoleExp
        {
			get
			{
				return _holeExp;
			}
			set
			{
				_holeExp = value;
				_isDirty = true;
			}
        }

        public int HoleLv
        {
			get
			{
				return _holeLv;
			}
			set
			{
				_holeLv = value;
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
    }
}
