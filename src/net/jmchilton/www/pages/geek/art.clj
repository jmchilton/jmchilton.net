(list 
  [:p "Here is some digital art I threw together years ago. I thought "
      "it was good at the time, not really anymore though. I guess I am not "
      "really sure why it is here, maybe just to fill out the website."]
  (vec 
    (cons :ul
      (map (fn [url name]
	           [:li [:a {"href"  (str "files/art/" url ".jpg")} name]])
	       (list "2bluesquares" "SunSpot" "blue" "beffy")
	       (list "2 Blue Squares" "SunSpot" "Blue" "Beffy")))))

