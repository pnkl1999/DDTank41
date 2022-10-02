namespace SqlDataProvider.Data
{
    public class SevenItem
    {
        private int _Index;

        private int _PosX;

        private int _Tag;

        private int _Type;

        public int Index
        {
			get
			{
				return _Index;
			}
			set
			{
				_Index = value;
			}
        }

        public int PosX
        {
			get
			{
				return _PosX;
			}
			set
			{
				_PosX = value;
			}
        }

        public int Tag
        {
			get
			{
				return _Tag;
			}
			set
			{
				_Tag = value;
			}
        }

        public int Type
        {
			get
			{
				return _Type;
			}
			set
			{
				_Type = value;
			}
        }

        public SevenItem()
        {
        }

        public SevenItem(int index, int type, int posx, int tag)
        {
			_Index = index;
			_Type = type;
			_PosX = posx;
			_Tag = tag;
        }
    }
}
