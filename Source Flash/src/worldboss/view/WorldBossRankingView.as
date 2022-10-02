package worldboss.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.geom.Rectangle;
   import worldboss.player.RankingPersonInfo;
   
   public class WorldBossRankingView extends Component
   {
       
      
      private var _titleBg:Bitmap;
      
      private var _container:VBox;
      
      public function WorldBossRankingView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._container = ComponentFactory.Instance.creatComponentByStylename("worldBossAward.rankingView.vbox");
         addChild(this._container);
      }
      
      public function set rankingInfos(param1:Vector.<RankingPersonInfo>) : void
      {
         var _loc3_:RankingPersonInfo = null;
         var _loc4_:RankingPersonInfoItem = null;
         var _loc5_:Rectangle = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:int = 1;
         for each(_loc3_ in param1)
         {
            _loc4_ = new RankingPersonInfoItem(_loc2_++,_loc3_,true);
            _loc5_ = ComponentFactory.Instance.creatCustomObject("worldbossAward.rankingItemSize");
            this._container.addChild(_loc4_);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeObject(this._container);
         this._container = null;
      }
   }
}
