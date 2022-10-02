using System;

namespace SqlDataProvider.Data
{
    public class TreasureDataInfo : DataObject
    {
        private DateTime _BeginDate;

        private int _Count;

        private int _ID;

        private bool _IsExit;

        private int _pos;

        private int _TemplateID;

        private int _UserID;

        private int _ValidDate;

        public DateTime BeginDate
        {
			get
			{
				return _BeginDate;
			}
			set
			{
				_BeginDate = value;
				_isDirty = true;
			}
        }

        public int Count
        {
			get
			{
				return _Count;
			}
			set
			{
				_Count = value;
				_isDirty = true;
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
				_isDirty = true;
			}
        }

        public bool IsExit
        {
			get
			{
				return _IsExit;
			}
			set
			{
				_IsExit = value;
				_isDirty = true;
			}
        }

        public int pos
        {
			get
			{
				return _pos;
			}
			set
			{
				_pos = value;
				_isDirty = true;
			}
        }

        public int TemplateID
        {
			get
			{
				return _TemplateID;
			}
			set
			{
				_TemplateID = value;
				_isDirty = true;
			}
        }

        public int UserID
        {
			get
			{
				return _UserID;
			}
			set
			{
				_UserID = value;
				_isDirty = true;
			}
        }

        public int ValidDate
        {
			get
			{
				return _ValidDate;
			}
			set
			{
				_ValidDate = value;
				_isDirty = true;
			}
        }
    }
}
