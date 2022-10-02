namespace Game.Logic.Actions
{
    public class CheckPVEGameStateAction : IAction
    {
        private long m_time;

        private bool m_isFinished;

        public CheckPVEGameStateAction(int delay)
        {
            m_time = TickHelper.GetTickCount() + delay;
            m_isFinished = false;
        }

        public void Execute(BaseGame game, long tick)
        {
            if (m_time > tick || game.GetWaitTimer() >= tick)
            {
                return;
            }
            PVEGame pve = game as PVEGame;
            if (pve != null)
            {
                switch (pve.GameState)
                {
                    case eGameState.Inited:
                        pve.Prepare();
                        break;
                    case eGameState.Prepared:
                        pve.PrepareNewSession();
                        break;
                    case eGameState.Loading:
                        if (pve.IsAllComplete())
                        {
                            pve.StartGame();
                        }
                        else
                        {
                            game.WaitTime(1000);
                        }
                        break;
                    case eGameState.GameStart:
                        if (game.RoomType == eRoomType.FightLab)
                        {
                            if (game.CurrentActionCount <= 1)
                            {
                                pve.PrepareFightingLivings();
                            }
                        }
                        else
                        {
                            pve.PrepareNewGame();
                        }
                        break;
                    case eGameState.Playing:
                        if ((pve.CurrentLiving != null && pve.CurrentLiving.IsAttacking) || game.CurrentActionCount > 1)
                        {
                            break;
                        }
                        if (pve.CanGameOver())
                        {
                            if (pve.IsLabyrinth() && pve.CanEnterGate)
                            {
                                pve.GameOverMovie();
                            }
                            else if (pve.CurrentActionCount <= 1)
                            {
                                if (!pve.IsCanPrepareGameOver())
                                    pve.GameOver();
                                else
                                    pve.PrepareGameOver();
                            }
                        }
                        else
                        {
                            if (pve.GameStateModify == eGameState.Waiting)
                            {
                                pve.WaitingGameState();
                                break;
                            }
                            pve.NextTurn();
                        }
                        break;
                    case eGameState.Waiting:
                        pve.WaitingGameState();
                        break;
                    case eGameState.PrepareGameOver:
                        if (pve.CanEndGame)
                        {
                            pve.GameOver();
                        }
                        else
                        {
                            pve.PrepareGameOver();
                        }
                        break;
                    case eGameState.GameOver:
                        if (!pve.HasNextSession())
                        {
                            pve.GameOverAllSession();
                        }
                        else
                        {
                            pve.PrepareNewSession();
                        }
                        break;
                    case eGameState.SessionPrepared:
                        if (pve.CanStartNewSession())
                        {
                            pve.SetupStyle();
                            pve.StartLoading();
                        }
                        else
                        {
                            game.WaitTime(1000);
                        }
                        break;
                    case eGameState.ALLSessionStopped:
                        if (pve.PlayerCount == 0 || pve.WantTryAgain == 0)
                        {
                            pve.Stop();
                        }
                        else if (pve.WantTryAgain == 1)
                        {
                            pve.ShowDragonLairCard();
                            pve.PrepareNewSession();
                        }
                        else if (pve.WantTryAgain == 2)
                        {
                            pve.SessionId--;
                            pve.PrepareNewSession();
                        }
                        else
                        {
                            game.WaitTime(1000);
                        }
                        break;
                }
            }
            m_isFinished = true;
        }

        public bool IsFinished(long tick)
        {
            return m_isFinished;
        }
    }
}
