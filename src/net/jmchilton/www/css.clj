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

(defn get-css [uri] 
  (css 
    (rule "*"
      :color text-color)

    (rule "a, a:visited, a:active"
      :color link-color
      :text-decoration "none")
    (rule "a:hover"
      :color active-link-color
      :text-decoration "underline")
    (rule "body"
      :margin (px 0)
      :padding (px 0)
      :background-color background-color
      :background-image 
      (format "url(bg%sx60-%sx40.png)" ; 0-%sx20-%sx10-%sx10-%sx10.png)" 
              background-color-str
              border-color-str
              background-color-str
              border-color-str
              background-color-str
              border-color-str)
      :background-repeat :repeat-x
      :font-family fonts
      :font-weight "bold"
      :font-size (em 1)
      :text-align "center")
    (rule "h2"
      :font-size (em 1.2)
      :font-weight "bold")           
    (rule "pre"
      :font-family fonts
      :font-weight "bold"
      :margin (px 0))
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
      :text-align :left
			:overflow :hidden)
    (rule "#content"
      :margin-top (px 5))
    (rule "#infoBox-container"
      :margin-top (px 0)
      :margin-bottom (px 10)
      :background-color background-color
      :background-image
      (format "url(bg%sx35-%sx15.png)"
              background-color-str
              infoBox-border-color-str)
      :background-repeat :repeat-x 
      :width "100%")        
    (rule "#infoBox-border"
      :background-color infoBox-border-color
      :margin-left :auto
      :margin-right (px 0)
      :width (px 450)
      :padding (px 5)
      :padding-right (px 0))
    (rule "#infoBox"
      :margin-right (px 0)
      :padding (px 5)
      :font-size (px 12)
      :text-align :right
      :background-color :white
      :border-right (px 0)
      :line-height (px 14))
    (rule "#infoBox p"
      :color infoBox-color
      :margin (px 0)
      :padding (px 0))
    (rule ".menu"
      :color other-text-color
      :overflow :hidden)
    (rule ".menu div"
      :color other-text-color)
    (rule ".menu ul"
      :padding (px 0)
      :margin (px 0)
      :list-style :none
      :width (% 100)
      :overflow :hidden)
    (rule ".menu li"
      :position :relative
      :width (% 20)
      :float :left)
    (rule ".treeList"
      :padding (px 0)
      :margin (px 0)
      :line-height (em 1.2)
    )
    (rule ".collapsable:hover"
      :color active-link-color)
    (rule ".collapsed:before"
      :content "\"+ \"")
    (rule ".uncollapsed:before"
      :content "\"- \"")
      
    (rule ".treeList ul"
      :display :block
      :padding (px 0) ; was 7
      :list-style :none
      :border-left [(px 2) :solid border-color]
      :border-bottom [(px 1) :solid border-color]
      :margin (px 6)
      :margin-right (px 1))
    (rule ".treeList li"
      :border-top [(px 1) :dashed border-color]
      :border-right [(px 1) :dashed border-color]
      :padding (px 7)
      :padding-right (px 7)
      :margin (px 0))
;    (rule ".treeList ul li:before"
;      :content "\"+ \"")
    (rule ".flatList"
      :display [:table :!important]
      :text-align :justify)
    (rule ".flatList ul"
      :margin (px 0)
      :padding (px 0)
      :display :inline
      :text-align :justify)
    (rule ".flatList li"
      :display :inline
      :margin (px 0)
      :padding (px 0)
      :padding-right (px 13)
      :padding-top (px 3)
      :float :left)
    (rule ".review"
;      :border [(px 1) :dashed border-color]
      :padding (px 5)
      :overflow :hidden
      :padding-bottom (px 10))
    (rule ".review-odd"
      :text-align :left)
    (rule ".review-even"
      :background-color other-text-color
      :text-align :right)
    (rule ".review-odd > img"
      :float :left)
    (rule ".review-even > img"
      :float :right)
    (rule ".review img"
      :padding (px 5))
    ;; Fix from page 93 of CSS Cookbox
    (rule ".review:after"
      :clear :both
      :display :block
      :content "\".\""
      :height (px 0)
      :visibility :hidden)       
    (rule ".review-title"
      :display :block
      :padding (px 0)
      :margin (px 0))
    (rule ".review-rating"
      :display :block
      :padding (px 0)
      :margin (px 0))
    (rule "#updates"
      :border-left [(px 1) :dashed border-color]
			:float :right
			:width (% 50)
			:padding (px 5)
      :padding-left (px 15)
			:font-size (em 0.85)
	  )
    (rule "#updates > p"
			:text-align :right
			:color background-color
			:padding (px 0)
			:margin (px 0))
    (rule ".update > a"
			:display :block
			:text-align :left
			:padding (px 0)
			:padding-left (px 18)
			:margin (px 0))
    (rule ".update > p"
			:display :block
			:text-align :left
			:padding (px 0)
			:margin (px 0))
	  (rule ".update-date"
		  :font-style :italic
		  :display :block
		  :text-align :right
		  :color other-text-color
			:padding (px 0)
		  :padding-bottom (px 15)
			:font-size (em 0.90)
			:margin (px 0))
    (rule ".code"
      :margin (px 10)
      :border [(px 1) :dashed border-color]
      :padding (px 5))))

