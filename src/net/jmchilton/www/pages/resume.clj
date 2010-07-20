(defn- a [url text] [:a {"href" url} text])

`([:h2 "An Overview"]
  [:p "Here are my " ~(a "files/chilton-resume.pdf" "resume (.pdf)") " and "
      ~(a "files/chilton-cv.pdf" "Curriculum Vitae (.pdf)") ".
      For more information on my academic record here is my "
      ~(a "files/transcript.html" "unofficial transcript") ".
      Also be sure to check out my " ~(a "http://www.linkedin.com/in/jmchilton" "LinkedIn") " profile."]

  [:h2 "Teaching"]

  [:p "Here is the most recent copy of my " ~(a "files/chilton-teaching-philosophy.pdf" "teaching philosophy") "."
      "For more insight into my teaching see my paper " ~(a "http://www.cs.hmc.edu/roboteducation/papers2007/c34_gini_umn.pdf"
      "Using the AIBOs in a CS1 Course") "."
      "I received many positive evaluations of my teaching, but I was only given electronic copies for one semester, here they are - "
      ~(a "files/eval-Spring2005-section04.pdf" "Spring 2005 - Section 04")
      " and "
      ~(a "files/eval-Spring2005-section05.pdf" "Spring 2005 - Section 05")
      "."]
 
  [:h2 "Professional Experience"]

  [:p "I am responsible for much of the software development at the " 
      ~(a "http://msi.umn.edu/" "Minnesota Supercomputing Institute") 
      ". I was the main implementer and architect and implementer of Tropix, TINT, ProTIP and the caGrid Introduction Extensions - 
      all featured on the "  ~(a "https://www.msi.umn.edu/development/software.html" "MSI software development page") "."] 
)
