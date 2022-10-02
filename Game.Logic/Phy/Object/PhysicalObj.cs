using Game.Logic.Actions;
using System.Collections.Generic;

namespace Game.Logic.Phy.Object
{
    public class PhysicalObj : Physics
    {
        private Dictionary<string, string> m_actionMapping = new Dictionary<string, string>();

        private string m_model;

        private string m_currentAction;

        private int m_scale;

        private int m_rotation;

        private BaseGame m_game;

        private bool m_canPenetrate;

        private string m_name;

        private int m_phyBringToFront;

        private int m_type;

        private int m_typeEffect;

        public virtual int Type
        {
			get
			{
				return m_type;
			}
			set
			{
				m_type = value;
			}
        }

        public string Model=> m_model;

        public string CurrentAction
        {
			get
			{
				return m_currentAction;
			}
			set
			{
				m_currentAction = value;
			}
        }

        public int Scale=> m_scale;

        public int Rotation=> m_rotation;

        public virtual int phyBringToFront=> m_phyBringToFront;

        public int typeEffect=> m_typeEffect;

        public bool CanPenetrate
        {
			get
			{
				return m_canPenetrate;
			}
			set
			{
				m_canPenetrate = value;
			}
        }

        public string Name=> m_name;

        public Dictionary<string, string> ActionMapping=> m_actionMapping;

        public void SetGame(BaseGame game)
        {
			m_game = game;
        }

        public void PlayMovie(string action, int delay, int movieTime)
        {
			if (m_game != null)
			{
				m_game.AddAction(new PhysicalObjDoAction(this, action, delay, movieTime));
			}
        }

        public override void CollidedByObject(Physics phy)
        {
			if (!m_canPenetrate && phy is SimpleBomb)
			{
				((SimpleBomb)phy).Bomb();
			}
        }

        public PhysicalObj(int id, string name, string model, string defaultAction, int scale, int rotation, int typeEffect)
			: base(id)
        {
			m_name = name;
			m_model = model;
			m_currentAction = defaultAction;
			m_scale = scale;
			m_rotation = rotation;
			m_canPenetrate = false;
			m_typeEffect = typeEffect;
			switch (name)
			{
			case "hide":
				m_phyBringToFront = 6;
				break;
			case "top":
				m_phyBringToFront = 1;
				break;
			case "normal":
				m_phyBringToFront = 0;
				break;
			default:
				m_phyBringToFront = -1;
				break;
			}
			if (model == "asset.game.six.ball")
			{
				if (!this.m_actionMapping.ContainsKey(defaultAction))
				{
					this.m_actionMapping.Add(defaultAction, this.getActionMap(defaultAction));
					return;
				}
			}
		}

        public PhysicalObj(int id, string name, string model, string defaultAction, int scale, int rotation, int typeEffect, bool canPenetrate)
			: base(id)
        {
			m_name = name;
			m_model = model;
			m_currentAction = defaultAction;
			m_scale = scale;
			m_rotation = rotation;
			m_canPenetrate = canPenetrate;
			m_typeEffect = typeEffect;
			switch (name)
			{
			case "hide":
				m_phyBringToFront = 6;
				break;
			case "top":
				m_phyBringToFront = 1;
				break;
			case "normal":
				m_phyBringToFront = 0;
				break;
			default:
				m_phyBringToFront = -1;
				break;
			}
			if (model == "asset.game.six.ball")
			{
				if (!this.m_actionMapping.ContainsKey(defaultAction))
				{
					this.m_actionMapping.Add(defaultAction, this.getActionMap(defaultAction));
					return;
				}
			}
		}
		private string getActionMap(string act)
		{
			switch (act)
			{
				case "s1":
					return "shield1";
				case "s2":
					return "shield2";
				case "s3":
					return "shield3";
				case "s4":
					return "shield4";
				case "s5":
					return "shield5";
				case "s6":
					return "shield6";
				case "s-1":
					return "shield-1";
				case "s-2":
					return "shield-2";
				case "s-3":
					return "shield-3";
				case "s-4":
					return "shield-4";
				case "s-5":
					return "shield-5";
				case "s-6":
					return "shield-6";
				case "double":
					return "shield-double";
			}
			return act;
		}
	}
}
