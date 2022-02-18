სინგულარის გასაშვებად  
ბექი (ყველა ეშვება სკრიპტების ფოლდერიდან):  
`./build-study.sh singular substitutions.conf --all`  
ან ნაბიჯ-ნაბიჯ თუ გინდათ:  
`./build-study.sh singular substitutions.conf --clean-db`  
`./build-study.sh singular substitutions.conf --build-pepper`
`./build-study.sh singular substitutions.conf --build-study`  
`./build-study.sh singular substitutions.conf --run-pepper`

<br>

ფრონტი:

`./render-client-config.sh singular singular` (ესეც სკრიპტების ფოლდერიდან)  
`ng serve ddp-singular` (ანგულარის ddp-workspace ფოლდერიდან)

<br>

ეს რა სთადიებიც გვაქ ყველას key და id ები (უახლესი ვერსია შეგიძლიათ ნახოთ ანგულარის რეპოში `ddp-angular\.circleci\config.yml` ფაილში)

```
  study_keys:
    basil dsm-ui osteo brain angio mbc testboston mpc prion atcp rarex rgp esc cgc circadia pancan singular brugada

  study_guids:
    basil NA CMI-OSTEO cmi-brain ANGIO cmi-mbc testboston cmi-mpc PRION atcp rarex RGP cmi-esc cgc circadia cmi-pancan singular brugada
```

<br>

---

<br>

ვინც პულ რექვესთს `ddp-study-server` რეპოზიტორიაში გააკეთებთ, გამერჯვის უფლება რო მოგცეთ უნდა გაუშვათ ავტოტესტები თქვენი ბრენჩისთვის.  
ჯერ ეს გაუშვით სადმე ტერმინალში:  
`echo 0eea16a9366eb4a199c6cc57e2e0db8a6d339f2a >> ~/.circleci-token` (ეს თუ არ გიქნიათ ერთხელ გაუშვით და მერე აღარ დაგჭირდებათ)

და ტესტინგი რო დაიწყოს ეს:  
`./run_ci_tests.sh <your_branch_name> ` (`ddp-study-server\pepper-apis\scripts` დირექტორიიდან)
<br>

---

<br>

`build-study.sh`-ის გამოყენების ინსტრუქციის სანახავად გაუშვით `-h/--help` არგუმენტით.  
მაგ: `./build-study.sh singular substitutions.conf -h`
