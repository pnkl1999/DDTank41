using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class SeventhSimpleCageNpc : ABrain
    {
        public override void OnStartAttacking()
        {
            if (Body.Blood == 0)
            {
                Out();
            }
        }
        
		private void Out()
        {
		    Body.PlayMovie("out", 3000, 0);
        }
    }
}
