(ns net.jmchilton.www.css) 

(use '(cssgen use types))
(use 'cssgen)

(def fonts "\"Inconsolata\", monospace")

(def background-color :#2956B2)
(def infoBox-border-color :#659CEF)
(def border-color :#7DBD00)
(def text-color :#000000)
(def other-text-color :#659CEF)
(def link-color :#2956B2)
(def active-link-color :#FF5B00)
(def page-color :white)
(def infoBox-color :#FF5B00)

(def background-color-str (.substring (name background-color) 1))
(def border-color-str (.substring (name border-color) 1))
(def infoBox-border-color-str (.substring (name infoBox-border-color) 1))

(def no-margin (mixin :margin (px 0)))
(def no-padding (mixin :padding (px 0)))
(def is-flush (mixin no-margin no-padding))

(def is-block (mixin :display :block))
(def is-inline (mixin :display :inline))

(def left-aligned (mixin :text-align :left))
(def right-aligned (mixin :text-align :right))

(defn get-css [uri] 
  (css 
    (rule "*"
      :color text-color)
    (rule "a, a:visited, a:active"
      :color link-color
      :text-decoration :none)
    (rule "a:hover"
      :color active-link-color
      :text-decoration :underline)
    (rule "body"
      no-margin 
      no-padding
      :background-color background-color
      :background-image 
      (format "url(bg%sx60-%sx6-%sx3-%sx40-%sx3-%sx6.png)" ; 0-%sx20-%sx10-%sx10-%sx10.png)" 
              background-color-str
              border-color-str
              background-color-str
              border-color-str
              background-color-str
              border-color-str)
      :background-repeat :repeat-x
      :font-family fonts
      :font-size (em 1)
      :text-align :center)
    (rule "h2"
      :font-size (em 1.2)
      :font-weight :bold)
    (rule "pre"
      :font-family fonts
      no-margin)
    (rule "#page-border"
      :margin "10px auto"
      :padding (px 8)
      :background-color border-color;
      :width (px 850))
    (rule "#page"
      :padding (px 5)
      :background-color page-color
      :margin-left :auto
      :margin-right :auto       
      left-aligned
			:overflow :hidden)
    (rule "#content"
      :margin-top (px 5))
    (rule "#infoBox"
      :margin-top (px 0)
      :margin-bottom (px 10)
      :background-color background-color
      :background-image
      (format "url(bg%sx16-%sx4-%sx2-%sx15-%sx2-%sx4.png)"
              background-color-str
              infoBox-border-color-str
              background-color-str
              infoBox-border-color-str
              background-color-str
              infoBox-border-color-str)
      :background-repeat :repeat-x 
      :width (% 100))
    (rule "#infoBox .border"
      :background-color infoBox-border-color
      :margin-left :auto
      :margin-right (px 0)
      :width (px 450)
      :padding (px 5)
      :padding-right (px 0))
    (rule "#infoBox .content"
      :margin-right (px 0)
      :padding (px 5)
      right-aligned
      :background-color page-color
      :border-right (px 0)
      :font-size (em 0.75))
    (rule "#infoBox p"
      :color infoBox-color
      no-margin
      no-padding)
    (rule "#shareBox"
      :margin-top (px -30)
      :margin-bottom (px 10)
      :background-color background-color
      :background-image
      (format "url(bg%sx25-%sx2-%sx1-%sx10-%sx1-%sx2.png)"
              background-color-str
              border-color-str
              background-color-str
              border-color-str
              background-color-str
              border-color-str)
      :background-repeat :repeat-x
      :width (% 100))
    (rule "#shareBox .border"
      :background-color border-color
      :margin-right :auto
      :margin-left (px 0)
      :width (px 350)
      :padding (px 5)
      :padding-left (px 0))
    (rule "#shareBox .content"
      no-margin
      no-padding
      :background-color page-color
      :vertical-align :middle
      left-aligned
      :border-right (px 0))
    (rule "#shareBox a"
      :vertical-align :middle
      :padding (px 0))
    (rule "#shareBox img"
      :margin (px 10)
      :vertical-align :middle)
    (rule "#shareBox iframe"
      :vertical-align :middle
      :margin (px 10)
      :padding (px 0))
;      :font-size (em 0.75))
    (rule ".menu"
      :color other-text-color
      :overflow :hidden)
    (rule ".menu div"
      :color other-text-color)
    (rule ".menu ul"
      no-margin
      no-padding
      :list-style :none
      :width (% 100)
      :overflow :hidden)
    (rule ".menu li"
      :font-weight :bold
      :position :relative
      :width (% 20)
      :float :left)
    (rule ".menu span"
      is-block
      )
    (rule ".treeList"
      is-flush
      :line-height (em 1.2)
    )
    (rule ".collapsable:hover"
      :cursor :pointer
      :color active-link-color)
    (rule ".collapsed:before"
      :content "\"+ \"")
    (rule ".uncollapsed:before"
      :content "\"- \"")
    (rule ".treeList ul"
      is-block
      no-padding
      :list-style :none
      :border-left [(px 2) :solid border-color]
      :border-bottom [(px 1) :solid border-color]
      :margin (px 6)
      :margin-right (px 1))
    (rule ".treeList li"
      :border-top [(px 1) :dashed border-color]
      :border-right [(px 1) :dashed border-color]
      :padding (px 7)
      no-margin)
    (rule ".flatList"
      :display [:table :!important]
      :text-align :justify)
    (rule ".flatList ul"
      is-flush
      :display :inline
      :text-align :justify)
    (rule ".flatList li"
      :display :inline
      is-flush
      :padding-right (px 13)
      :padding-top (px 3)
      :float :left)
    (rule ".review"
      :padding (px 5)
      :overflow :hidden
      :padding-bottom (px 10))
    (rule ".review-odd"
      left-aligned)
    (rule ".review-even"
      :background-color other-text-color
      right-aligned)
    (rule ".review-odd > img"
      :float :left)
    (rule ".review-even > img"
      :float :right)
    (rule ".review img"
      :padding (px 5))
    (rule ".review-title"
      is-block
      is-flush)
    (rule ".review-rating"
      is-block
      is-flush)
    (rule "#updates"
      :border-left [(px 1) :dashed border-color]
			:float :right
			:width (% 50)
			:padding (px 5)
      :padding-left (px 15)
			:font-size (em 0.85))
    (rule "#updates > p"
			right-aligned
      :font-weight :bold
			:color background-color
      is-flush)
    (rule ".update > a"
      :font-weight :bold
      :color other-text-color
			is-block
			left-aligned
      is-flush
			:padding-left (px 18))
    (rule ".update > p"
			is-block
			left-aligned
      is-flush)
	  (rule ".update-date"
		  :font-style :italic
		  is-block
		  right-aligned
		  :color background-color
      is-flush
		  :padding-bottom (px 15)
			:font-size (em 0.90))
    (rule ".code"
      :margin (px 10)
      :border [(px 1) :dashed border-color]
      :padding (px 5))))
