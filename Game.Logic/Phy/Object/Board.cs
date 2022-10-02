using System.Drawing;

namespace Game.Logic.Phy.Object
{
    public class Board : Physics
    {
        private int _type;

        private int _templateId;

        private int _valueType;

        private int _value;

        private int _rotate;

        private int _state;

        public int Type
        {
			get
			{
				return _type;
			}
			set
			{
				_type = value;
			}
        }

        public int TemplateId
        {
			get
			{
				return _templateId;
			}
			set
			{
				_templateId = value;
			}
        }

        public int ValueType
        {
			get
			{
				return _valueType;
			}
			set
			{
				_valueType = value;
			}
        }

        public int Value
        {
			get
			{
				return _value;
			}
			set
			{
				_value = value;
			}
        }

        public int Rotate
        {
			get
			{
				return _rotate;
			}
			set
			{
				_rotate = value;
			}
        }

        public int State
        {
			get
			{
				return _state;
			}
			set
			{
				_state = value;
			}
        }

        public Board(int id, int type, int templateId, int valueType, int value, int rotate, int state)
			: base(id)
        {
			_type = type;
			_templateId = templateId;
			_valueType = valueType;
			_value = value;
			_rotate = rotate;
			_state = state;
			m_rect = new Rectangle(-52, -9, 104, 20);
        }

        public Board(int id, int templateId, int valueType, int value)
			: base(id)
        {
			_templateId = templateId;
			_valueType = valueType;
			_value = value;
			m_rect = new Rectangle(-52, -9, 104, 20);
        }
    }
}
