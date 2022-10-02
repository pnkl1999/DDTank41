using System;
namespace SqlDataProvider.Data
{
	public class UserGemStone : DataObject
	{
		private int _ID;
		private int _userID;
		private int _figSpiritId;
		private string _figSpiritIdValue;
		private int _equipPlace;
		public int ID
		{
			get
			{
				return this._ID;
			}
			set
			{
				this._ID = value;
				this._isDirty = true;
			}
		}
		public int UserID
		{
			get
			{
				return this._userID;
			}
			set
			{
				this._userID = value;
				this._isDirty = true;
			}
		}
		public int FigSpiritId
		{
			get
			{
				return this._figSpiritId;
			}
			set
			{
				this._figSpiritId = value;
				this._isDirty = true;
			}
		}
		public string FigSpiritIdValue
		{
			get
			{
				return this._figSpiritIdValue;
			}
			set
			{
				this._figSpiritIdValue = value;
				this._isDirty = true;
			}
		}
		public int EquipPlace
		{
			get
			{
				return this._equipPlace;
			}
			set
			{
				this._equipPlace = value;
				this._isDirty = true;
			}
		}

		private int m_currentlevel;
		public int CurrentLevel
		{
			get
			{
				return this.m_currentlevel;
			}
			set
			{
				this.m_currentlevel = value;
				this._isDirty = true;
			}
		}
	}
}
