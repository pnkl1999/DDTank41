using System;

namespace SqlDataProvider.Data
{
    public class QuestDataInfo : DataObject
    {
        private DateTime _completeDate;

        private int _condition1;

        private int _condition2;

        private int _condition3;

        private int _condition4;

        private bool _isComplete;

        private bool _isExist;

        private int _questID;

        private int _randDobule;

        private int _repeatFinish;

        private int _userID;

        public DateTime CompletedDate
        {
			get
			{
				return _completeDate;
			}
			set
			{
				_completeDate = value;
				_isDirty = true;
			}
        }

        public int Condition1
        {
			get
			{
				return _condition1;
			}
			set
			{
				if (value != _condition1)
				{
					_condition1 = value;
					_isDirty = true;
				}
			}
        }

        public int Condition2
        {
			get
			{
				return _condition2;
			}
			set
			{
				if (value != _condition2)
				{
					_condition2 = value;
					_isDirty = true;
				}
			}
        }

        public int Condition3
        {
			get
			{
				return _condition3;
			}
			set
			{
				if (value != _condition3)
				{
					_condition3 = value;
					_isDirty = true;
				}
			}
        }

        public int Condition4
        {
			get
			{
				return _condition4;
			}
			set
			{
				if (value != _condition4)
				{
					_condition4 = value;
					_isDirty = true;
				}
			}
        }

        public bool IsComplete
        {
			get
			{
				return _isComplete;
			}
			set
			{
				_isComplete = value;
				_isDirty = true;
			}
        }

        public bool IsExist
        {
			get
			{
				return _isExist;
			}
			set
			{
				_isExist = value;
				_isDirty = true;
			}
        }

        public int QuestID
        {
			get
			{
				return _questID;
			}
			set
			{
				_questID = value;
				_isDirty = true;
			}
        }

        public int RandDobule
        {
			get
			{
				return _randDobule;
			}
			set
			{
				_randDobule = value;
				_isDirty = true;
			}
        }

        public int RepeatFinish
        {
			get
			{
				return _repeatFinish;
			}
			set
			{
				_repeatFinish = value;
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

        public int GetConditionValue(int index)
        {
			return index switch
			{
				0 => Condition1, 
				1 => Condition2, 
				2 => Condition3, 
				3 => Condition4, 
				_ => throw new Exception("Quest condition index out of range."), 
			};
        }

        public void SaveConditionValue(int index, int value)
        {
			switch (index)
			{
			case 0:
				Condition1 = value;
				break;
			case 1:
				Condition2 = value;
				break;
			case 2:
				Condition3 = value;
				break;
			case 3:
				Condition4 = value;
				break;
			default:
				throw new Exception("Quest condition index out of range.");
			}
        }
    }
}
