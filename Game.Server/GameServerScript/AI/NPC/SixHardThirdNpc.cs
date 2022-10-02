using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using System.Drawing;
using Game.Logic.Actions;
using Bussiness;
using Game.Logic.Effects;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class SixHardThirdNpc : ABrain
    {
        private int m_attackTurn = 0;

        private bool m_runEffectBlock = false;

        private Player m_lastAttack;

        Dictionary<int, int> m_countPlayerDamage = new Dictionary<int, int>();

        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            m_body.CurrentDamagePlus = 1;
            m_body.CurrentShootMinus = 1;
        }

        public override void OnCreated()
        {
            base.OnCreated();
            Body.MaxBeatDis = 200;
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();

            m_attackTurn++;

            if (m_runEffectBlock)
            {
                m_runEffectBlock = false;
                int countAttack = m_countPlayerDamage[m_lastAttack.PlayerDetail.PlayerCharacter.ID];
                if (countAttack > 2)
                {
                    Body.Say("<span class='red'>" + m_lastAttack.PlayerDetail.PlayerCharacter.NickName + "</span> nhắc nhiều vẫn lì. Ra khỏi sân ngay!!", 0, 1000);
                    Body.PlayMovie("beat", 1000, 5000);
                    m_lastAttack.SyncAtTime = true;
                    m_lastAttack.Die();
                }
                else if (countAttack == 2)
                {
                    Body.Say("<span class='red'>" + m_lastAttack.PlayerDetail.PlayerCharacter.NickName + "</span> đánh trọng tài lần nữa ta sẽ đuổi khỏi sân.", 0, 1000, 4000);
                }
                else
                {
                    Body.Say("<span class='red'>" + m_lastAttack.PlayerDetail.PlayerCharacter.NickName + "</span> đánh trọng tài là vi phạm quy tắc.", 0, 1000, 4000);
                }
            }
        }

        public override void OnDie()
        {
            base.OnDie();
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }

        public override void OnAfterTakedBomb()
        {
            base.OnAfterTakedBomb();
        }

        public override void OnAfterTakeDamage(Living source)
        {
            base.OnAfterTakeDamage(source);

            if (source is Player && m_runEffectBlock == false)
            {
                m_lastAttack = (source as Player);

                int userId = (source as Player).PlayerDetail.PlayerCharacter.ID;

                if (m_countPlayerDamage.ContainsKey(userId))
                {
                    m_countPlayerDamage[userId]++;
                }
                else
                {
                    m_countPlayerDamage.Add(userId, 1);
                }
                (Game as PVEGame).SendLivingActionMapping(Body, "stand", "stand");

                (Body as SimpleBoss).Delay = Game.GetLowDelayTurn() - 1;

                m_runEffectBlock = true;

                Body.Config.CompleteStep = false;
            }
        }
    }
}
