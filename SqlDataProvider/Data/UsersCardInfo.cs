namespace SqlDataProvider.Data
{
    public class UsersCardInfo : DataObject
    {
        private int int_0;

        private int int_1;

        private int int_2;

        private int int_3;

        private int int_4;

        private int int_5;

        private int int_6;

        private int int_7;

        private int int_8;

        private int int_9;

        private int int_10;

        private int int_11;

        private int int_12;

        private int int_13;

        private int int_14;

        private int int_15;

        private int int_16;

        private bool bool_0;

        public int CardID
        {
			get
			{
				return int_0;
			}
			set
			{
				int_0 = value;
				_isDirty = true;
			}
        }

        public int UserID
        {
			get
			{
				return int_1;
			}
			set
			{
				int_1 = value;
				_isDirty = true;
			}
        }

        public int TemplateID
        {
			get
			{
				return int_2;
			}
			set
			{
				int_2 = value;
				_isDirty = true;
			}
        }

        public int Place
        {
			get
			{
				return int_3;
			}
			set
			{
				int_3 = value;
				_isDirty = true;
			}
        }

        public int Count
        {
			get
			{
				return int_4;
			}
			set
			{
				int_4 = value;
				_isDirty = true;
			}
        }

        public int Attack
        {
			get
			{
				return int_5;
			}
			set
			{
				int_5 = value;
				_isDirty = true;
			}
        }

        public int Defence
        {
			get
			{
				return int_6;
			}
			set
			{
				int_6 = value;
				_isDirty = true;
			}
        }

        public int Agility
        {
			get
			{
				return int_7;
			}
			set
			{
				int_7 = value;
				_isDirty = true;
			}
        }

        public int Luck
        {
			get
			{
				return int_8;
			}
			set
			{
				int_8 = value;
				_isDirty = true;
			}
        }

        public int AttackReset
        {
			get
			{
				return int_9;
			}
			set
			{
				int_9 = value;
				_isDirty = true;
			}
        }

        public int DefenceReset
        {
			get
			{
				return int_10;
			}
			set
			{
				int_10 = value;
				_isDirty = true;
			}
        }

        public int AgilityReset
        {
			get
			{
				return int_11;
			}
			set
			{
				int_11 = value;
				_isDirty = true;
			}
        }

        public int LuckReset
        {
			get
			{
				return int_12;
			}
			set
			{
				int_12 = value;
				_isDirty = true;
			}
        }

        public int TotalAttack=> int_5 + int_9;

        public int TotalDefence=> int_6 + int_10;

        public int TotalAgility=> int_7 + int_11;

        public int TotalLuck=> int_8 + int_12;

        public int Guard
        {
			get
			{
				return int_13;
			}
			set
			{
				int_13 = value;
				_isDirty = true;
			}
        }

        public int Damage
        {
			get
			{
				return int_14;
			}
			set
			{
				int_14 = value;
				_isDirty = true;
			}
        }

        public int Level
        {
			get
			{
				return int_15;
			}
			set
			{
				int_15 = value;
				_isDirty = true;
			}
        }

        public int CardGP
        {
			get
			{
				return int_16;
			}
			set
			{
				int_16 = value;
				_isDirty = true;
			}
        }

        public bool isFirstGet
        {
			get
			{
				return bool_0;
			}
			set
			{
				bool_0 = value;
				_isDirty = true;
			}
        }

        public UsersCardInfo()
        {
        }

        public UsersCardInfo(int userId, int templateId, int count)
        {
			int_0 = 0;
			int_1 = userId;
			int_2 = templateId;
			int_4 = count;
			bool_0 = true;
        }

        public void Copy(UsersCardInfo copy)
        {
			UserID = copy.UserID;
			TemplateID = copy.TemplateID;
			Place = copy.Place;
			Count = copy.Count;
			Attack = copy.Attack;
			Defence = copy.Defence;
			Agility = copy.Agility;
			Luck = copy.Luck;
			AttackReset = copy.AttackReset;
			DefenceReset = copy.DefenceReset;
			AgilityReset = copy.AgilityReset;
			LuckReset = copy.LuckReset;
			Guard = copy.Guard;
			Damage = copy.Damage;
			Level = copy.Level;
			CardGP = copy.CardGP;
			isFirstGet = copy.isFirstGet;
        }

        public void CopyProp(UsersCardInfo copy)
        {
			Attack = copy.Attack;
			Defence = copy.Defence;
			Agility = copy.Agility;
			Luck = copy.Luck;
			AttackReset = copy.AttackReset;
			DefenceReset = copy.DefenceReset;
			AgilityReset = copy.AgilityReset;
			LuckReset = copy.LuckReset;
			Guard = copy.Guard;
			Damage = copy.Damage;
			Level = copy.Level;
			CardGP = copy.CardGP;
        }

        public UsersCardInfo Clone()
        {
			return new UsersCardInfo
			{
				UserID = int_1,
				TemplateID = int_2,
				Place = int_3,
				Count = int_4,
				Attack = int_5,
				Defence = int_6,
				Agility = int_7,
				Luck = int_8,
				AttackReset = int_9,
				DefenceReset = int_10,
				AgilityReset = int_11,
				LuckReset = int_12,
				Guard = int_13,
				Damage = int_14,
				Level = int_15,
				CardGP = int_16,
				isFirstGet = bool_0
			};
        }
    }
}
