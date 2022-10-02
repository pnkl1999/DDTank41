using System;

namespace SqlDataProvider.Data
{
    public class UserRankInfo : DataObject
    {
        private bool _isExit;

        private int _userID;

        private NewTitleInfo _info;

        private DateTime _endDate;

        private DateTime _beginDate;

        private int _id;

        private int _newTitleid;

        private string _name;

        private int _validate;

        private int _attack;

        private int _defence;

        private int _luck;

        private int _agility;

        private int _hp;

        private int _damage;

        private int _guard;

        public NewTitleInfo Info
        {
			get
			{
				return _info;
			}
			set
			{
				_info = value;
			}
        }

        public DateTime EndDate
        {
			get
			{
				return _endDate;
			}
			set
			{
				_endDate = value;
				_isDirty = true;
			}
        }

        public DateTime BeginDate
        {
			get
			{
				return _beginDate;
			}
			set
			{
				_beginDate = value;
				_isDirty = true;
			}
        }

        public bool IsExit
        {
			get
			{
				return _isExit;
			}
			set
			{
				_isExit = value;
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

        public int ID
        {
			get
			{
				return _id;
			}
			set
			{
				_id = value;
				_isDirty = true;
			}
        }

        public int NewTitleID
        {
			get
			{
				return _newTitleid;
			}
			set
			{
				_newTitleid = value;
				_isDirty = true;
			}
        }

        public string Name
        {
			get
			{
				return _name;
			}
			set
			{
				_name = value;
				_isDirty = true;
			}
        }

        public int Validate
        {
			get
			{
				return _validate;
			}
			set
			{
				_validate = value;
				_isDirty = true;
			}
        }

        public int Attack
        {
			get
			{
				return _attack;
			}
			set
			{
				_attack = value;
				_isDirty = true;
			}
        }

        public int Defence
        {
			get
			{
				return _defence;
			}
			set
			{
				_defence = value;
				_isDirty = true;
			}
        }

        public int Luck
        {
			get
			{
				return _luck;
			}
			set
			{
				_luck = value;
				_isDirty = true;
			}
        }

        public int Agility
        {
			get
			{
				return _agility;
			}
			set
			{
				_agility = value;
				_isDirty = true;
			}
        }

        public int HP
        {
			get
			{
				return _hp;
			}
			set
			{
				_hp = value;
				_isDirty = true;
			}
        }

        public int Damage
        {
			get
			{
				return _damage;
			}
			set
			{
				_damage = value;
				_isDirty = true;
			}
        }

        public int Guard
        {
			get
			{
				return _guard;
			}
			set
			{
				_guard = value;
				_isDirty = true;
			}
        }

        public bool IsValidRank()
        {
			if (_validate > 0)
			{
				return DateTime.Compare(_beginDate.AddDays(_validate), DateTime.Now) > 0;
			}
			return true;
        }
    }
}
