package cardSystem
{
   import cardSystem.analyze.CardPropIncreaseRuleAnalyzer;
   import cardSystem.analyze.SetsPropertiesAnalyzer;
   import cardSystem.analyze.SetsSortRuleAnalyzer;
   import cardSystem.analyze.UpgradeRuleAnalyzer;
   import cardSystem.data.CardInfo;
   import cardSystem.model.CardModel;
   import cardSystem.view.PropResetFrame;
   import cardSystem.view.UpGradeFrame;
   import cardSystem.view.cardCollect.CardCollectView;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import flash.events.EventDispatcher;
   
   public class CardControl extends EventDispatcher
   {
      
      private static var _instance:CardControl;
      
      private static var _firstShow:Boolean = true;
       
      
      private var _model:CardModel;
      
      public var signLockedCard:int;
      
      public function CardControl()
      {
         super();
         this._model = new CardModel();
      }
      
      public static function get Instance() : CardControl
      {
         if(_instance == null)
         {
            _instance = new CardControl();
         }
         return _instance;
      }
      
      public function setSignLockedCardNone() : void
      {
         this.signLockedCard = -1;
      }
      
      public function get model() : CardModel
      {
         return this._model;
      }
      
      public function showUpGradeFrame(param1:CardInfo) : void
      {
         var _loc2_:UpGradeFrame = ComponentFactory.Instance.creatComponentByStylename("UpGradeFrame");
         _loc2_.cardInfo = param1;
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function showPropResetFrame(param1:CardInfo) : void
      {
         var _loc2_:PropResetFrame = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame");
         _loc2_.show(param1);
      }
      
      public function showCollectView() : void
      {
         var _loc1_:CardCollectView = ComponentFactory.Instance.creatComponentByStylename("CardCollectView");
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function initSetsProperties(param1:SetsPropertiesAnalyzer) : void
      {
         this._model.setsList = param1.setsList;
      }
      
      public function initSetsSortRule(param1:SetsSortRuleAnalyzer) : void
      {
         this._model.setsSortRuleVector = param1.setsVector;
      }
      
      public function initSetsUpgradeRule(param1:UpgradeRuleAnalyzer) : void
      {
         this._model.upgradeRuleVec = param1.upgradeRuleVec;
      }
      
      public function initPropIncreaseRule(param1:CardPropIncreaseRuleAnalyzer) : void
      {
         this._model.propIncreaseDic = param1.propIncreaseDic;
      }
   }
}
