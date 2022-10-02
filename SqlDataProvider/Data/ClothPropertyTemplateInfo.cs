using System;

namespace SqlDataProvider.Data
{
	public class ClothPropertyTemplateInfo
	{
		private int _Agility;

		private int _Attack;

		private int _Blood;

		private int _Cost;

		private int _Damage;

		private int _Defend;

		private int _Guard;

		private int _id;

		private int _Luck;

		private string _name;

		private int _Sex;

		public int Agility
		{
			get
			{
				return this._Agility;
			}
			set
			{
				this._Agility = value;
			}
		}

		public int Attack
		{
			get
			{
				return this._Attack;
			}
			set
			{
				this._Attack = value;
			}
		}

		public int Blood
		{
			get
			{
				return this._Blood;
			}
			set
			{
				this._Blood = value;
			}
		}

		public int Cost
		{
			get
			{
				return this._Cost;
			}
			set
			{
				this._Cost = value;
			}
		}

		public int Damage
		{
			get
			{
				return this._Damage;
			}
			set
			{
				this._Damage = value;
			}
		}

		public int Defend
		{
			get
			{
				return this._Defend;
			}
			set
			{
				this._Defend = value;
			}
		}

		public int Guard
		{
			get
			{
				return this._Guard;
			}
			set
			{
				this._Guard = value;
			}
		}

		public int ID
		{
			get
			{
				return this._id;
			}
			set
			{
				this._id = value;
			}
		}

		public int Luck
		{
			get
			{
				return this._Luck;
			}
			set
			{
				this._Luck = value;
			}
		}

		public string Name
		{
			get
			{
				return this._name;
			}
			set
			{
				this._name = value;
			}
		}

		public int Sex
		{
			get
			{
				return this._Sex;
			}
			set
			{
				this._Sex = value;
			}
		}
	}
}
