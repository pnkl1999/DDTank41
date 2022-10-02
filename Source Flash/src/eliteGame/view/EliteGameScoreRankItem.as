package eliteGame.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import eliteGame.info.EliteGameScroeRankInfo;
   import flash.display.Sprite;
   
   public class EliteGameScoreRankItem extends Sprite implements Disposeable
   {
       
      
      private var _topThree:ScaleFrameImage;
      
      private var _rank:FilterFrameText;
      
      private var _name:FilterFrameText;
      
      private var _score:FilterFrameText;
      
      public function EliteGameScoreRankItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._topThree = ComponentFactory.Instance.creatComponentByStylename("eliteGame.scoreRankView.topThree");
         this._rank = ComponentFactory.Instance.creatComponentByStylename("eliteGame.scoreItem.rank");
         this._name = ComponentFactory.Instance.creatComponentByStylename("eliteGame.scoreItem.name");
         this._score = ComponentFactory.Instance.creatComponentByStylename("eliteGame.scoreItem.score");
         addChild(this._topThree);
         addChild(this._rank);
         addChild(this._name);
         addChild(this._score);
         this._topThree.visible = false;
      }
      
      public function set info(param1:EliteGameScroeRankInfo) : void
      {
         switch(param1.rank)
         {
            case 1:
               this._topThree.setFrame(1);
               this._topThree.visible = true;
               this._rank.visible = false;
               break;
            case 2:
               this._topThree.setFrame(2);
               this._topThree.visible = true;
               this._rank.visible = false;
               break;
            case 3:
               this._topThree.setFrame(3);
               this._topThree.visible = true;
               this._rank.visible = false;
               break;
            default:
               this._rank.text = param1.rank + "th";
               this._topThree.visible = false;
               this._rank.visible = true;
         }
         this._name.text = param1.nickName;
         this._score.text = param1.scroe.toString();
      }
      
      public function dispose() : void
      {
         if(this._rank)
         {
            ObjectUtils.disposeObject(this._rank);
         }
         this._rank = null;
         if(this._name)
         {
            ObjectUtils.disposeObject(this._name);
         }
         this._name = null;
         if(this._score)
         {
            ObjectUtils.disposeObject(this._score);
         }
         this._score = null;
         if(this._topThree)
         {
            ObjectUtils.disposeObject(this._topThree);
         }
         this._topThree = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
