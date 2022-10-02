package ddt.view.academyCommon.recommend
{
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.AcademyFrameManager;
   import ddt.manager.AcademyManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.MouseEvent;
   
   public class RecommendMasterPlayerCellView extends RecommendPlayerCellView implements Disposeable
   {
       
      
      public function RecommendMasterPlayerCellView()
      {
         super();
      }
      
      override protected function initRecommendBtn() : void
      {
         _recommendBtn = ComponentFactory.Instance.creatComponentByStylename("academyCommon.RecommendPlayerCellView.apprentice");
         addChild(_recommendBtn);
         _btnLight = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,_recommendBtn,"asset.academy.BtnLight",PositionUtils.creatPoint("ddt.view.academyCommon.recommend.BtnlightPint"));
         _btnLight.stop();
      }
      
      override protected function __recommendBtn(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!AcademyManager.Instance.compareState(_info.info,PlayerManager.Instance.Self))
         {
            return;
         }
         if(AcademyManager.Instance.isFreezes(false))
         {
            AcademyFrameManager.Instance.showAcademyRequestApprenticeFrame(_info.info);
         }
      }
   }
}
