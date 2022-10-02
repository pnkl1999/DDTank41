using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic.Effects;
using Game.Logic;
using Game.Logic.Actions;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class ThirdSimpleFagNpc : ABrain
    {
        private Player m_target= null;

        private int m_targetDis = 0;
		
        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            Body.CurrentDamagePlus = 1;
            Body.CurrentShootMinus = 1;

        }

        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();
            List<Player> players = Game.GetAllLivingPlayers();

            foreach (Player player in players)
                {
                    //player.AddEffect(new ContinueReduceBloodEffect(2,-50), 0);//phong
					player.AddEffect(new ReduceStrengthEffect(2,50), 0);//met
					//player.AddEffect(new LockDirectionEffect(2), 0);//khoa
					//player.AddEffect(new ContinueReduceDamageEffect(2), 0);//ko bk
					//player.SendGameUpdateNoHoleState;
					//player.EffectList.Remove(null);
					//EffectList.StopEffect(new ReduceStrengthEffect(2));
                }


        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
			List<Player> players = Game.GetAllLivingPlayers();
			foreach (Player player in players)
                {
                    //player.AddEffect(new ContinueReduceBloodEffect(2,-50), 0);//phong
					//player.AddEffect(new ReduceStrengthEffect(2), 0);//met
					//player.AddEffect(new LockDirectionEffect(2), 0);//khoa
					//player.AddEffect(new ContinueReduceDamageEffect(2), 0);//ko bk
					//player.SendGameUpdateNoHoleState;
					Body.Say("Haha, tôi là đầy sức mạnh!", 1, 0);
					player.EffectList.Remove(null);
					//EffectList.StopEffect(new ReduceStrengthEffect(2));
                }
        }

    }
}
