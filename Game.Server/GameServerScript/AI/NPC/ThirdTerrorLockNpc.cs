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
    public class ThirdTerrorLockNpc : ABrain
    {
        private int m_turn = 0;

        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();

            m_turn++;
            if (m_turn >= 4)
                Body.Die();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            Body.CurrentDamagePlus = 1;
            Body.CurrentShootMinus = 1;
        }

        public override void OnDie()
        {
            base.OnDie();
            StopEffect();
        }

        private void StopEffect()
        {
            List<Player> players = Game.GetAllLivingPlayers();

            foreach (Player player in players)
            {
                LockDirectionEffect effect = player.EffectList.GetOfType(eEffectType.LockDirectionEffect) as LockDirectionEffect;

                if (effect != null)
                    effect.Stop();
            }
        }

        public override void OnCreated()
        {
            base.OnCreated();
            List<Player> players = Game.GetAllLivingPlayers();

            foreach (Player player in players)
            {
                LockDirectionEffect effect = player.EffectList.GetOfType(eEffectType.LockDirectionEffect) as LockDirectionEffect;
                if (effect == null)
                {
                    player.AddEffect(new LockDirectionEffect(200), 0);//khoa
                }
            }
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }

    }
}
