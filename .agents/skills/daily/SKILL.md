---
name: daily
description: Use when initializing the next Daily source and note files in the shared .NET Console project in the backend-daily-practice repository.
---

# Daily Exercise Initialization

Initialize only the next coding environment. Do not generate an exercise, syllabus, learning progress, solution, per-Day project, commit, or push.

1. Resolve the Git repository root and confirm it is `backend-daily-practice`.
2. Run the bundled script from the repository root:

```powershell
$repoRoot = (git rev-parse --show-toplevel).Trim()
& (Join-Path $repoRoot '.agents\skills\daily\scripts\New-DailyExercise.ps1') -RepositoryRoot $repoRoot
```

3. Let the script exclusively determine the latest `dayXX`, validate the shared root project, create the next `Program.cs` and `doc.md`, switch the project's single `Compile` item, and run the shared project.
4. Stop and report the script error without guessing, deleting additional files, or modifying an existing Daily.
5. Report the created source and note files, selected shared-project source, and `dotnet run` result.
