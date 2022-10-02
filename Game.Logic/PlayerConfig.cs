using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Game.Logic
{
    public class PlayerConfig
    {
        private bool m_isAddTurn;

        public bool IsAddTurn
        {
            get { return m_isAddTurn; }
            set { m_isAddTurn = value; }
        }
        private bool m_isMoving;

        public bool IsMoving
        {
            get { return m_isMoving; }
            set { m_isMoving = value; }
        }

        public PlayerConfig()
        {
            m_isAddTurn = false;
            m_isMoving = true;
        }
    }
}
