namespace SqlDataProvider.Data
{
    public class MarryProp
    {
        private bool _isCreatedMarryRoom;

        private bool _isGotRing;

        private bool _isMarried;

        private int _selfMarryRoomID;

        private int _spouseID;

        private string _spouseName;

        public bool IsCreatedMarryRoom
        {
			get
			{
				return _isCreatedMarryRoom;
			}
			set
			{
				_isCreatedMarryRoom = value;
			}
        }

        public bool IsGotRing
        {
			get
			{
				return _isGotRing;
			}
			set
			{
				_isGotRing = value;
			}
        }

        public bool IsMarried
        {
			get
			{
				return _isMarried;
			}
			set
			{
				_isMarried = value;
			}
        }

        public int SelfMarryRoomID
        {
			get
			{
				return _selfMarryRoomID;
			}
			set
			{
				_selfMarryRoomID = value;
			}
        }

        public int SpouseID
        {
			get
			{
				return _spouseID;
			}
			set
			{
				_spouseID = value;
			}
        }

        public string SpouseName
        {
			get
			{
				return _spouseName;
			}
			set
			{
				_spouseName = value;
			}
        }
    }
}
